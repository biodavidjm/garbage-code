create table band
(
    band_id                 serial                         ,
    band_name               varchar(64)             not null,
    country                 varchar(32)                     ,
    fan_id                  integer                         ,
    CONSTRAINT              band_id PRIMARY KEY(band_id)
);

create table album
(   
    album_id                serial                      ,
    album_name              varchar(64)         not null,
    album_year              integer(4)                  ,
    band_id                 integer             not null,
    style                   varchar                     ,
    CONSTRAINT              album_pk PRIMARY KEY(album_id)
);

create table song
(
    song_id                 serial                      ,
    song_name               varchar(128)        not null,
    duration                date interval               ,
    track_number            integer                     ,  
    album_id                integer             not null,
    CONSTRAINT              song_pk PRIMARY KEY(song_id)
);

create table playlist
(
    playlist_id             serial                      ,
    playlist_name           varchar(128)        not null,
    song_id                 integer             not null,
    CONSTRAINT              playlist_pk PRIMARY KEY(playlist_id)  
);

create table style
(
    style_name              varchar(128),
    CONSTRAINT              style_pk PRIMARY KEY(style_name)
);

create table shows_go
(
    show_date               date                not null,
    city                    varchar(64)         not null,
    country                 varchar(64)                 ,
    opinion                 integer                     ,
    band_id                 integer         not null,
    CONSTRAINT              shows_go_pk PRIMARY KEY(show_date)
);

create table get_it_from
(
    friend_id               serial          not null,
    friend_fn               varchar(64)     not null,
    friend_ln               varchar(128)    not null,
    band_id                 integer         not null,
    CONSTRAINT              shows_go_pk PRIMARY KEY(friend_id)
);

create table fan
(
    fan_id                  serial          not null,
    fan_fname               varchar(64)     not null,
    fan_lname               varchar(128)    not null,
    band_id                 integer         not null,
    CONSTRAINT              shows_go_pk PRIMARY KEY(fan_id)
);


