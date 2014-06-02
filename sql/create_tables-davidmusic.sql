create table artist
(
    artist_id               serial                         ,
    artist_name             varchar(64)             not null,
    country                 varchar(32)                     ,
    CONSTRAINT              artist_id PRIMARY KEY(artist_id)
);

create table album
(   
    album_id                serial                      ,
    album_name              varchar(64)         not null,
    album_year              integer(4)                  ,
    artist_id               integer             not null,
    style                   varchar                     ,
    CONSTRAINT              album_pk PRIMARY KEY(album_id)
);

create table song
(
    song_id                 serial                      ,
    song_name               varchar(128)        not null,
    duration                date interval               ,  
    album_id                integer             not null,
    artist_id               integer             not null,
    CONSTRAINT              song_pk PRIMARY KEY(song_id)
);


create table style
(
    style_name              varchar(128),
    CONSTRAINT              style_pk PRIMARY KEY(style_name)
);


create table playlist
(
    playlist_id             serial                      ,
    playlist_name           varchar(128)        not null,
    song_id                 integer             not null,
    CONSTRAINT              playlist_pk PRIMARY KEY(playlist_id)  
);
