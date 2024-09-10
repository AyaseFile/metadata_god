use std::path::Path;
use anyhow::{anyhow, Result};
use id3::{Tag as Id3Tag, TagLike};
use lofty::config::WriteOptions;
use lofty::file::TaggedFile;
use lofty::picture::{MimeType, PictureType};
use lofty::prelude::{Accessor, AudioFile, ItemKey, TagExt, TaggedFileExt};
use lofty::properties::FileProperties;
use lofty::tag::{ItemValue, Tag as LoftyTag};

#[derive(Debug)]
pub struct Picture {
    /// The picture's MIME type.
    pub mime_type: String,
    /// The image data.
    pub data: Vec<u8>,
}

#[derive(Debug)]
pub enum TagType {
    Ape,
    Id3,
    Vorbis,
    Riff,
    Unknown,
}

impl From<lofty::tag::TagType> for TagType {
    fn from(lofty_tag_type: lofty::tag::TagType) -> Self {
        match lofty_tag_type {
            lofty::tag::TagType::Ape => TagType::Ape,
            lofty::tag::TagType::Id3v1 => TagType::Id3,
            lofty::tag::TagType::Id3v2 => TagType::Id3,
            lofty::tag::TagType::VorbisComments => TagType::Vorbis,
            lofty::tag::TagType::RiffInfo => TagType::Riff,
            _ => TagType::Unknown,
        }
    }
}

#[derive(Debug)]
pub struct Metadata {
    pub tag_type: TagType,
    pub title: Option<String>,
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
}

pub fn lofty_read_metadata(file: String) -> Result<Metadata> {
    let mut tagged_file = lofty::read_from_path(file)?;
    let tag = match tagged_file.primary_tag_mut() {
        Some(primary_tag) => primary_tag,
        None => {
            if let Some(first_tag) = tagged_file.first_tag_mut() {
                first_tag
            } else {
                return Err(anyhow!("No tags found"));
            }
        }
    };
    let cover = tag
        .get_picture_type(PictureType::CoverFront)
        .or(tag.pictures().first());
    Ok(Metadata {
        tag_type: tag.tag_type().into(),
        title: tag.title().and_then(|s| Some(s.to_string())),
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
    })
}

pub fn lofty_write_metadata(file: String, metadata: Metadata, create_tag_if_missing: bool) -> Result<TagType> {
    let mut tag = get_or_create_tag_for_file(&file, create_tag_if_missing)?;

    fn set_or_remove(tag: &mut LoftyTag, key: ItemKey, value: Option<String>) -> Result<()> {
        match value {
            Some(v) => {
                if !tag.insert_text(key.clone(), v) {
                    return Err(anyhow!("Failed to insert text for key: {:?}", key));
                }
            }
            None => {
                tag.remove_key(&key);
            }
        }
        Ok(())
    }

    set_or_remove(&mut tag, ItemKey::TrackTitle, metadata.title)?;
    set_or_remove(&mut tag, ItemKey::AlbumTitle, metadata.album)?;
    set_or_remove(&mut tag, ItemKey::AlbumArtist, metadata.album_artist)?;
    set_or_remove(&mut tag, ItemKey::TrackArtist, metadata.artist)?;
    set_or_remove(&mut tag, ItemKey::TrackNumber, metadata.track_number.map(|n| n.to_string()))?;
    set_or_remove(&mut tag, ItemKey::TrackTotal, metadata.track_total.map(|n| n.to_string()))?;
    set_or_remove(&mut tag, ItemKey::DiscNumber, metadata.disc_number.map(|n| n.to_string()))?;
    set_or_remove(&mut tag, ItemKey::DiscTotal, metadata.disc_total.map(|n| n.to_string()))?;
    set_or_remove(&mut tag, ItemKey::Year, metadata.year.map(|y| y.to_string()))?;
    set_or_remove(&mut tag, ItemKey::Genre, metadata.genre)?;

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
    Ok(tag.tag_type().into())
}

fn get_or_create_tag_for_file(file: &str, create_if_missing: bool) -> Result<LoftyTag> {
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

    match tagged_file.primary_tag_mut() {
        Some(primary_tag) => Ok(primary_tag.to_owned()),
        None => {
            if let Some(first_tag) = tagged_file.first_tag_mut() {
                Ok(first_tag.to_owned())
            } else {
                if !create_if_missing {
                    return Err(anyhow!("No tags found"));
                }
                let tag_type = tagged_file.primary_tag_type();
                eprintln!("WARN: No tags found, creating a new tag of type `{tag_type:?}`");
                tagged_file.insert_tag(LoftyTag::new(tag_type));
                Ok(tagged_file.primary_tag_mut().unwrap().to_owned())
            }
        }
    }
}

pub fn id3_read_metadata(file: String) -> Result<Metadata> {
    let path = Path::new(&file);
    let tag = Id3Tag::read_from_path(path)?;
    let metadata = Metadata {
        tag_type: TagType::Id3,
        title: tag.title().and_then(|s| Some(s.to_string())),
        album: tag.album().and_then(|s| Some(s.to_string())),
        album_artist: tag.album_artist().and_then(|s| Some(s.to_string())),
        artist: tag.artist().and_then(|s| Some(s.to_string())),
        track_number: tag.track().map(|f| f as u16),
        track_total: tag.total_tracks().map(|f| f as u16),
        disc_number: tag.disc().map(|f| f as u16),
        disc_total: tag.total_discs().map(|f| f as u16),
        year: tag.year().map(|f| f),
        genre: tag.genre().and_then(|s| Some(s.to_string())),
        picture: tag
            .pictures()
            .find(|p| p.picture_type == id3::frame::PictureType::CoverFront)
            .map(|p| Picture {
                mime_type: p.mime_type.clone(),
                data: p.data.clone(),
            }),
    };
    Ok(metadata)
}

pub fn id3_write_metadata(file: String, metadata: Metadata) -> Result<()> {
    let path = Path::new(&file);
    let mut tag = Id3Tag::read_from_path(path)?;

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
        tag.set_album_artist(album_artist);
    } else {
        tag.remove_album_artist();
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
        tag.set_total_tracks(track_total as u32);
    } else {
        tag.remove_total_tracks();
    }

    if let Some(disc_number) = metadata.disc_number {
        tag.set_disc(disc_number as u32);
    } else {
        tag.remove_disc();
    }

    if let Some(disc_total) = metadata.disc_total {
        tag.set_total_discs(disc_total as u32);
    } else {
        tag.remove_total_discs();
    }

    if let Some(year) = metadata.year {
        tag.set_year(year);
    } else {
        tag.remove_year();
    }

    if let Some(genre) = metadata.genre {
        tag.set_genre(genre);
    } else {
        tag.remove_genre();
    }

    if let Some(picture) = metadata.picture {
        let picture_type = id3::frame::PictureType::CoverFront;
        let picture = id3::frame::Picture {
            mime_type: picture.mime_type.parse()?,
            picture_type,
            description: String::new(),
            data: picture.data,
        };
        tag.add_frame(picture);
    } else {
        tag.remove_picture_by_type(id3::frame::PictureType::CoverFront);
    }

    tag.write_to_path(path, id3::Version::Id3v24)?;
    Ok(())
}