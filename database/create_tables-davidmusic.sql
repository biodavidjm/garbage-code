create table band
(
    band_id                 serial           PRIMARY KEY,
    band_name               varchar(128)       not null,
    country                 varchar(128)
);

create table album
(   
    album_id                serial           PRIMARY KEY,
    album_name              varchar(128)        not null,
    album_year              integer                     ,
    band_id                 integer             not null,
    CONSTRAINT album_band_id_fk FOREIGN KEY(band_id) REFERENCES band(band_id)
);

-- ALTER TABLE song ADD COLUMN itunes_id integer;
-- ALTER TABLE song DROP COLUMN duration;
-- ALTER TABLE song ADD COLUMN duration integer;
create table song
(
    song_id                 integer           PRIMARY KEY,
    song_name               varchar(128)        not null,
    duration                integer                     ,
    track_number            integer                     ,  
    itunes_id               integer                     ,
    album_id                integer             not null,
    CONSTRAINT song_album_id_fk FOREIGN KEY(album_id) REFERENCES album(album_id)
);

create table playlist
(
    playlist_id             serial           PRIMARY KEY,
    playlist_name           varchar(128)        not null
);

create table song_playlist
(
    song_id                 integer             not null,
    playlist_id             integer             not null,
    CONSTRAINT song_playlist_song_id_fk FOREIGN KEY(song_id) REFERENCES song(song_id),
    CONSTRAINT song_playlist_playlist_fk FOREIGN KEY(playlist_id) REFERENCES playlist(playlist_id)

);

create table style
(
    style_id                serial           PRIMARY KEY,
    style_name              varchar(128)         not null
);

create table song_style
(
    song_id                 integer             not null,
    style_id                integer             not null,
    CONSTRAINT song_playlist_song_id_fk FOREIGN KEY(song_id) REFERENCES song(song_id),
    CONSTRAINT song_playlist_style_id_fk FOREIGN KEY(style_id) REFERENCES style(style_id)
);

create table show
(
    show_id                 serial            PRIMARY KEY,
    show_date               date                 not null,
    city                    varchar(128)         not null,
    country                 varchar(128)                 ,
    opinion                 integer CHECK( opinion < 6)                     
);

create table band_show
(
    show_id                 integer             not null,
    band_id                 integer             not null,
    CONSTRAINT band_show_show_id_fk FOREIGN KEY(show_id) REFERENCES show(show_id),
    CONSTRAINT band_show_band_id_fk FOREIGN KEY(band_id) REFERENCES band(band_id)
);

create table source
(
    source_id               serial           PRIMARY KEY,
    source_fn               varchar(128)         not null,
    source_ln               varchar(128)         not null
);

create table band_source
(
    band_id                 integer         not null,
    source_id               integer         not null,
    CONSTRAINT band_source_band_id_fk   FOREIGN KEY(band_id) REFERENCES band(band_id),
    CONSTRAINT band_source_source_id_fk FOREIGN KEY(source_id) REFERENCES source(source_id)
);

-- ALTER TABLE fan RENAME COLUMN fan_fname TO fan_name;
create table fan
(
    fan_id                  serial          PRIMARY KEY,
    fan_name               varchar(128)       not null
);

create table band_fan
(
    band_id                 integer         not null,
    fan_id                  integer         not null,
    CONSTRAINT band_fan_band_id_fk  FOREIGN KEY(band_id) REFERENCES band(band_id),
    CONSTRAINT band_fan_fan_id_fk  FOREIGN KEY(fan_id) REFERENCES fan(fan_id)
);


