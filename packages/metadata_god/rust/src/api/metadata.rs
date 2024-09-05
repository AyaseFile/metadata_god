use anyhow::{anyhow, Result};
use lofty::config::WriteOptions;
use lofty::file::TaggedFile;
use lofty::picture::{MimeType, PictureType};
use lofty::prelude::{Accessor, AudioFile, ItemKey, TagExt, TaggedFileExt};
use lofty::properties::FileProperties;
use lofty::tag::{ItemValue, Tag};

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

    fn set_or_remove(tag: &mut Tag, key: ItemKey, value: Option<String>) {
        match value {
            Some(v) => { tag.insert_text(key, v); }
            None => { tag.remove_key(&key); }
        }
    }

    set_or_remove(&mut tag, ItemKey::TrackTitle, metadata.title);
    set_or_remove(&mut tag, ItemKey::AlbumTitle, metadata.album);
    set_or_remove(&mut tag, ItemKey::AlbumArtist, metadata.album_artist);
    set_or_remove(&mut tag, ItemKey::TrackArtist, metadata.artist);
    set_or_remove(&mut tag, ItemKey::TrackNumber, metadata.track_number.map(|n| n.to_string()));
    set_or_remove(&mut tag, ItemKey::TrackTotal, metadata.track_total.map(|n| n.to_string()));
    set_or_remove(&mut tag, ItemKey::DiscNumber, metadata.disc_number.map(|n| n.to_string()));
    set_or_remove(&mut tag, ItemKey::DiscTotal, metadata.disc_total.map(|n| n.to_string()));
    set_or_remove(&mut tag, ItemKey::Year, metadata.year.map(|y| y.to_string()));
    set_or_remove(&mut tag, ItemKey::Genre, metadata.genre);

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

    let tag = get_or_create_tag(&mut tagged_file);
    Ok((tagged_file, tag))
}

fn get_tag_for_file(file: &str) -> Result<(TaggedFile, Tag)> {
    let mut tagged_file = lofty::read_from_path(file)?;
    let tag = get_or_create_tag(&mut tagged_file);
    Ok((tagged_file, tag))
}

fn get_or_create_tag(tagged_file: &mut TaggedFile) -> Tag {
    match tagged_file.primary_tag_mut() {
        Some(primary_tag) => primary_tag.to_owned(),
        None => {
            if let Some(first_tag) = tagged_file.first_tag_mut() {
                first_tag.to_owned()
            } else {
                let tag_type = tagged_file.primary_tag_type();

                eprintln!("WARN: No tags found, creating a new tag of type `{tag_type:?}`");
                tagged_file.insert_tag(Tag::new(tag_type));

                tagged_file.primary_tag_mut().unwrap().to_owned()
            }
        }
    }
}
