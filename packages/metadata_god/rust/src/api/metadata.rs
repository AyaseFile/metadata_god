use anyhow::{anyhow, Result};
use lofty::config::WriteOptions;
use lofty::file::TaggedFile;
use lofty::picture::{MimeType, PictureType};
use lofty::prelude::{Accessor, AudioFile, ItemKey, TagExt, TaggedFileExt};
use lofty::properties::FileProperties;
use lofty::tag::{ItemValue, Tag, TagItem};

#[derive(Debug)]
pub struct Picture {
    /// The picture's MIME type.
    pub mime_type: String,
    /// The image data.
    pub data: Vec<u8>,
}

#[derive(Debug)]
pub struct Metadata {
    pub title: Option<String>,
    pub duration_ms: Option<f64>,
    pub artist: Option<String>,
    pub album: Option<String>,
    pub album_artist: Option<String>,
    pub track_number: Option<u16>,
    pub track_total: Option<u16>,
    pub disc_number: Option<u16>,
    pub disc_total: Option<u16>,
    pub year: Option<i32>,
    pub genre: Option<String>,
    pub picture: Option<Picture>,
    pub file_size: Option<u64>,
}

pub fn read_metadata(file: String) -> Result<Metadata> {
    let (tagged_file, tag) = get_tag_for_file(&file)?;
    let cover = tag
        .get_picture_type(PictureType::CoverFront)
        .or(tag.pictures().first());
    Ok(Metadata {
        title: tag.title().and_then(|s| Some(s.to_string())),
        duration_ms: Some(tagged_file.properties().duration().as_millis() as f64),
        album: tag.album().and_then(|s| Some(s.to_string())),
        album_artist: tag
            .get(&ItemKey::AlbumArtist)
            .and_then(|s| match s.value() {
                ItemValue::Text(t) => Some(t.to_string()),
                _ => None,
            }),
        artist: tag.artist().and_then(|s| Some(s.to_string())),
        track_number: tag.track().map(|f| f as u16),
        track_total: tag.track_total().map(|f| f as u16),
        disc_number: tag.disk().map(|f| f as u16),
        disc_total: tag.disk_total().map(|f| f as u16),
        year: tag.year().map(|f| f as i32),
        genre: tag.genre().and_then(|s| Some(s.to_string())),
        picture: (match cover {
            Some(cover) => Some(Picture {
                mime_type: cover.mime_type().map(|m| m.to_string()).unwrap_or_default(),
                data: cover.data().to_vec(),
            }),
            None => None,
        }),
        file_size: Some(21231_u64),
    })
}

pub fn write_metadata(file: String, metadata: Metadata) -> Result<()> {
    let (_tagged_file, mut tag) = open_or_create_tag_for_file(&file)?;

    if let Some(title) = metadata.title {
        tag.set_title(title);
    } else {
        tag.remove_title();
    }
    if let Some(album) = metadata.album {
        tag.set_album(album);
    } else {
        tag.remove_album();
    }
    if let Some(album_artist) = metadata.album_artist {
        tag.insert(TagItem::new(
            ItemKey::AlbumArtist,
            ItemValue::Text(album_artist),
        ));
    } else {
        tag.remove_key(&ItemKey::AlbumArtist);
    }
    if let Some(artist) = metadata.artist {
        tag.set_artist(artist);
    } else {
        tag.remove_artist();
    }
    if let Some(track_number) = metadata.track_number {
        tag.set_track(track_number as u32);
    } else {
        tag.remove_track();
    }
    if let Some(track_total) = metadata.track_total {
        tag.set_track_total(track_total as u32);
    } else {
        tag.remove_track_total();
    }
    if let Some(disc_number) = metadata.disc_number {
        tag.set_disk(disc_number as u32);
    } else {
        tag.remove_disk();
    }
    if let Some(disc_total) = metadata.disc_total {
        tag.set_disk_total(disc_total as u32);
    } else {
        tag.remove_disk_total();
    }
    if let Some(year) = metadata.year {
        tag.set_year(year as u32);
    } else {
        tag.remove_year();
    }
    if let Some(genre) = metadata.genre {
        tag.set_genre(genre);
    } else {
        tag.remove_genre();
    }
    if let Some(picture) = metadata.picture {
        let cover_front_index = tag
            .pictures()
            .iter()
            .position(|p| p.pic_type() == PictureType::CoverFront);
        let new_picture = lofty::picture::Picture::new_unchecked(
            PictureType::CoverFront,
            Some(MimeType::from_str(&picture.mime_type)),
            None,
            picture.data.clone(),
        );
        if let Some(index) = cover_front_index {
            tag.set_picture(index, new_picture);
        } else {
            tag.push_picture(new_picture);
        }
    } else {
        tag.remove_picture_type(PictureType::CoverFront);
    }

    tag.save_to_path(&file, WriteOptions::default())?;
    Ok(())
}

fn open_or_create_tag_for_file(file: &str) -> Result<(TaggedFile, Tag)> {
    let mut tagged_file = match lofty::read_from_path(file) {
        Ok(tagged_file) => tagged_file,
        _ => {
            let prob = lofty::probe::Probe::open(file)?;

            if prob.file_type().is_none() {
                return Err(anyhow!("File type could not be determined"));
            }

            TaggedFile::new(prob.file_type().unwrap(), FileProperties::default(), vec![])
        }
    };

    let tag = match tagged_file.primary_tag_mut() {
        Some(primary_tag) => primary_tag,
        None => {
            if let Some(first_tag) = tagged_file.first_tag_mut() {
                first_tag
            } else {
                let tag_type = tagged_file.primary_tag_type();

                eprintln!("WARN: No tags found, creating a new tag of type `{tag_type:?}`");
                tagged_file.insert_tag(Tag::new(tag_type));

                tagged_file.primary_tag_mut().unwrap()
            }
        }
    }
    .to_owned();
    Ok((tagged_file, tag))
}

fn get_tag_for_file(file: &str) -> Result<(TaggedFile, Tag)> {
    let mut tagged_file = lofty::read_from_path(file)?;

    let tag = match tagged_file.primary_tag_mut() {
        Some(primary_tag) => primary_tag,
        None => {
            if let Some(first_tag) = tagged_file.first_tag_mut() {
                first_tag
            } else {
                let tag_type = tagged_file.primary_tag_type();

                eprintln!("WARN: No tags found, creating a new tag of type `{tag_type:?}`");
                tagged_file.insert_tag(Tag::new(tag_type));

                tagged_file.primary_tag_mut().unwrap()
            }
        }
    }
    .to_owned();
    Ok((tagged_file, tag))
}
