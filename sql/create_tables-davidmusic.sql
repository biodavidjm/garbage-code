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
    album_year              integer(128)                ,
    band_id                 integer             not null,
    CONSTRAINT album_band_id_fk FOREIGN KEY(band_id) REFERENCES band(band_id)
);

create table song
(
    song_id                 serial           PRIMARY KEY,
    song_name               varchar(128)        not null,
    duration                date interval               ,
    track_number            integer                     ,  
    album_id                integer             not null,
    CONSTRAINT song_album_id_fk FOREIGN KEY(album_id) REFERENCES album(album_id)
);

create table playlist
(
    playlist_id             serial           PRIMARY KEY,
    playlist_name           varchar(128)        not null,
    song_id                 integer             not null,
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
    style_name              varchar(128)         not null,
    song_id                 integer             not null,
    CONSTRAINT song_style_song_id_fk FOREIGN KEY(song_id) REFERENCES song(song_id)
);

create table show
(
    show_id                 serial           PRIMARY KEY,
    show_date               date                not null,
    city                    varchar(64)         not null,
    country                 varchar(64)                 ,
    opinion                 integer                     
);

create table show_band
(
    show_id                 integer             not null,
    band_id                 integer             not null,
    CONSTRAINT show_band_show_id_fk FOREIGN KEY(show_id) REFERENCES show(show_id),
    CONSTRAINT show_band_band_id_fk FOREIGN KEY(band_id) REFERENCES band(band_id)
);

create table source
(
    friend_id               serial           PRIMARY KEY,
    friend_fn               varchar(64)         not null,
    friend_ln               varchar(128)        not null
);

create table band_source
(
    band_id                 integer         not null,
    source_id               integer         not null,
    CONSTRAINT band_source_band_id_fk   FOREIGN KEY(band_id) REFERENCES band(band_id),
    CONSTRAINT band_source_source_id_fk FOREIGN KEY(source_id) REFERENCES source(source_id)
);

create table fan
(
    fan_id                  serial          PRIMARY KEY,
    fan_fname               varchar(128)       not null,
);

create table band_fan
(
    band_id                 integer         not null,
    fan_id                  integer         not null,
    CONSTRAINT band_fan_band_id_fk  FOREIGN KEY(band_id) REFERENCES band(band_id),
    CONSTRAINT band_fan_fan_id_fk  FOREIGN KEY(fan_id) REFERENCES fan(fan_id)
);


