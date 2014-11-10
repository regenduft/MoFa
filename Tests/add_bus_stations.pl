#!/usr/bin/perl
use strict;
use warnings;

use lib('../');
use Mofa::MeetingPt;
use Mofa::Model;

my @stations;

sub coords($$) {
    my ( $x, $y ) = @_;

    # Abzw. Uni und Schillerplatz:
    my ( $xpix1,  $xpix2 )  = ( 151,     326 );
    my ( $xreal1, $xreal2 ) = ( 409331,  410793 );
    my ( $ypix1,  $ypix2 )  = ( 326,     3 );
    my ( $yreal1, $yreal2 ) = ( 5475434, 5477697 );

#push(@stations, [347,279,20,'Ludwig-Erhard-Str.',6091204,0]);#408362 // 5475014
#push(@stations, [97,16,20,'Opelkreisel',6091224,0]);#406262 // 5477255
    ( $xpix1,  $xpix2 )  = ( 97,      347 );
    ( $xreal1, $xreal2 ) = ( 406262,  408362 );
    ( $ypix1,  $ypix2 )  = ( 16,      279 );
    ( $yreal1, $yreal2 ) = ( 5477255, 5475014 );

#push(@stations, [377,25,20,'Friedhof Eingang West',6091304,0]);#412870 // 5477949
#push(@stations, [12,321,20,'Uni Ost',6091310,0]);#409703 // 5475313
    ( $xpix1,  $xpix2 )  = ( 377,     12 );
    ( $xreal1, $xreal2 ) = ( 412870,  409703 );
    ( $ypix1,  $ypix2 )  = ( 25,      321 );
    ( $yreal1, $yreal2 ) = ( 5477949, 5475313 );

    #push(@stations, [12,311,20,'Erbsenberg',6091274,0]);#411685 // 5476827
    #push(@stations, [360,32,20,'Eselsfürth',6091084,0]);#414630 // 5479273
    ( $xpix1,  $xpix2 )  = ( 12,      360 );
    ( $xreal1, $xreal2 ) = ( 411685,  414630 );
    ( $ypix1,  $ypix2 )  = ( 311,     32 );
    ( $yreal1, $yreal2 ) = ( 5476827, 5479273 );

#push(@stations, [431,325,20,'Alte Brücke',6091008,0]);#409277 // 5477743
#push(@stations, [160,8,20,'Erfenbach Sportplatz',6091078,0]);#406948 // 5480451
    ( $xpix1,  $xpix2 )  = ( 431,     160 );
    ( $xreal1, $xreal2 ) = ( 409277,  406948 );
    ( $ypix1,  $ypix2 )  = ( 325,     8 );
    ( $yreal1, $yreal2 ) = ( 5477743, 5480451 );

#push(@stations, [428,283,20,'Friedhof Eingang West',6091304,0]);#412870 // 5477949
#push(@stations, [9,159,20,'Engelshof',6091068,0]);#409266 // 5478999
    ( $xpix1,  $xpix2 )  = ( 428,     9 );
    ( $xreal1, $xreal2 ) = ( 412870,  409266 );
    ( $ypix1,  $ypix2 )  = ( 283,     159 );
    ( $yreal1, $yreal2 ) = ( 5477949, 5478999 );

    my $xreal = $xreal2
        - ( ( $xreal2 - $xreal1 ) / ( $xpix2 - $xpix1 ) * ( $xpix2 - $x ) );
    my $yreal = $yreal2
        - ( ( $yreal2 - $yreal1 ) / ( $ypix2 - $ypix1 ) * ( $ypix2 - $y ) );

    return ( int($xreal), int($yreal) );
}

push( @stations, [ 151, 265, 20, 'Abzw. Universität',   6091238, 0 ] );
push( @stations, [ 285, 88,  20, 'Addi-Schaurer-Platz', 6091232, 0 ] );
push( @stations, [ 364, 88,  20, 'Agentur für Arbeit',  1903,    7312000 ] );
push( @stations, [ 400, 28,  20, 'Albrechtstr.',        6006214, 0 ] );
push( @stations, [ 338, 53,  20, 'Alleestr.',           6091007, 0 ] );
push( @stations, [ 138, 245, 20, 'Am Harzhübel',        6091016, 0 ] );
push( @stations,
    [ 322, 111, 20, 'Amtsgericht (Justizzentr.)', 1937, 7312000 ] );
push( @stations, [ 266, 19, 20, 'Apostelkirche', 6091019, 0 ] );
push( @stations, [ 257, 16, 20, 'Apostelkirche', 1987,    7312000 ] );
push( @stations, [ 373, 91, 20, 'Arbeitsamt',    6091020, 0 ] );
push( @stations,
    [ 322, 111, 20, 'Arbeitsgericht (Justizzentr.)', 1938, 7312000 ] );
push( @stations,
    [ 362, 257, 20, 'Ausbildungszentr. der HWK', 1706, 7312000 ] );
push( @stations, [ 17,  84,  20, 'Bahnheim',         6091027, 0 ] );
push( @stations, [ 236, 178, 20, 'Balbierstr.',      6091030, 0 ] );
push( @stations, [ 206, 214, 20, 'Barbarossahalle',  1894,    7312000 ] );
push( @stations, [ 390, 73,  20, 'Barbarossaschule', 1725,    7312000 ] );
push( @stations, [ 408, 80,  20, 'Barbarossastr.',   6091032, 0 ] );
push( @stations, [ 364, 22,  20, 'Behördenhaus',     1904,    7312000 ] );
push( @stations, [ 299, 19, 20, 'Benedict-Sprachschule', 1707, 7312000 ] );
push( @stations,
    [ 343, 249, 20, 'Bertha-v.-Suttner-Ges.schule', 1727, 7312000 ] );
push( @stations, [ 421, 192, 20, 'Betzenberg',          6091036, 0 ] );
push( @stations, [ 413, 219, 20, 'Betzenbergschule',    1759,    7312000 ] );
push( @stations, [ 346, 20,  20, 'BfA',                 1905,    7312000 ] );
push( @stations, [ 352, 24,  20, 'Bismarckstr.',        6009050, 0 ] );
push( @stations, [ 252, 131, 20, 'Blücherstr. Abzw.',   6091148, 0 ] );
push( @stations, [ 221, 216, 20, 'Buchenlochstr.',      6091043, 0 ] );
push( @stations, [ 275, 183, 20, 'Casimirring Nord',    6091046, 0 ] );
push( @stations, [ 291, 196, 20, 'Casimirring Süd',     6091047, 0 ] );
push( @stations, [ 285, 184, 20, 'Christ-König Kirche', 1990,    7312000 ] );
push( @stations, [ 116, 75,  20, 'DRK-Seniorenzentrum', 1844,    7312000 ] );
push( @stations, [ 41,  161, 20, 'Damaschkestr.',       6091049, 0 ] );
push( @stations, [ 212, 156, 20, 'Dammstr.',            6091050, 0 ] );
push( @stations, [ 123, 252, 20, 'Davenportplatz',      6091054, 0 ] );
push( @stations,
    [ 379, 83, 20, 'Deutsches Rotes Kreuz (DRK)', 1837, 7312000 ] );
push( @stations, [ 249, 78,  20, 'Diakonissenheim', 1873, 7312000 ] );
push( @stations, [ 428, 183, 20, 'Dorimare',        1830, 7312000 ] );
push( @stations,
    [ 347, 20, 20, 'Dt. Angestellten-Akad. (DAA)', 1710, 7312000 ] );
push( @stations, [ 342, 182, 20, 'Dunkeltälchen',  6091060, 0 ] );
push( @stations, [ 66,  35,  20, 'Dürerstr.',      6091061, 0 ] );
push( @stations, [ 259, 135, 20, 'E-Werk',         6091062, 0 ] );
push( @stations, [ 29,  86,  20, 'Eichamt',        1907,    7312000 ] );
push( @stations, [ 425, 102, 20, 'Erbsenberg',     6091274, 0 ] );
push( @stations, [ 304, 11,  20, 'Fackelbrunnen',  6091169, 0 ] );
push( @stations, [ 294, 24,  20, 'Fackelpassage',  6091302, 0 ] );
push( @stations, [ 286, 28,  20, 'Fackelwoogstr.', 6091091, 0 ] );
push( @stations, [ 115, 84,  20, 'Feuerwache',     6091348, 0 ] );
push( @stations, [ 89,  80,  20, 'Feuerwache',     1908,    7312000 ] );
push( @stations, [ 345, 92,  20, 'Finanzamt',      6009041, 0 ] );
push( @stations, [ 341, 86,  20, 'Finanzamt',      1909,    7312000 ] );
push( @stations,
    [ 343, 71, 20, 'Fortbild.akad. Wirtsch. (FAW)', 1711, 7312000 ] );
push( @stations,
    [ 279, 27, 20, 'Franziskanerinnen Kapelle', 1993, 7312000 ] );
push( @stations, [ 186, 183, 20, 'Fraunhofer Zentrum', 6091365, 0 ] );
push( @stations, [ 181, 175, 20, 'Fraunhofer-Zentrum', 5050,    7312000 ] );
push( @stations, [ 64,  280, 20, 'Friedenskirche',     1994,    7312000 ] );
push( @stations,
    [ 386, 150, 20, 'Fritz-Walter-Stadion', 2147003013, 7312000 ] );
push( @stations, [ 329, 0, 20, 'Fruchthalle', 1897, 7312000 ] );
push( @stations, [ 108, 128, 20, 'Galgenschanze Bahnhof', 6008186, 0 ] );
push( @stations, [ 150, 74,  20, 'Galgenschanze TWK',     6091350, 0 ] );
push( @stations, [ 190, 77,  20, 'Gesundheitsamt',     1911,    7312000 ] );
push( @stations, [ 191, 51,  20, 'Goetheschule',       6091107, 0 ] );
push( @stations, [ 193, 61,  20, 'Goetheschule (IGS)', 1764,    7312000 ] );
push( @stations, [ 231, 86,  20, 'Graviusheim',        1874,    7312000 ] );
push( @stations, [ 140, 155, 20, 'Gusswerk',           6091113, 0 ] );
push( @stations,
    [ 318, 21, 20, 'Handwerkskammer der Pfalz', 1838, 7312000 ] );
push( @stations, [ 240, 66,  20, 'Hartmannstr.', 6091115, 0 ] );
push( @stations, [ 316, 119, 20, 'Hauptbahnhof', 6009035, 0 ] );
push( @stations, [ 416, 194, 20, 'Hegelstr.',    6091133, 0 ] );
push( @stations,
    [ 254, 240, 20, 'Heinrich-Heine-Gymnasium', 1769, 7312000 ] );
push( @stations, [ 240, 225, 20, 'Hermann-Löns-Str.',      6091126, 0 ] );
push( @stations, [ 62,  177, 20, 'Hohenecker Str.',        6091118, 0 ] );
push( @stations, [ 173, 84,  20, 'Hohenstaufen Gymnasium', 6091194, 0 ] );
push( @stations, [ 157, 84, 20, 'Hohenstaufen-Gymnasium', 1770, 7312000 ] );
push( @stations, [ 261, 216, 20, 'Im Busch',         6091153, 0 ] );
push( @stations, [ 240, 212, 20, 'Im Kuckuckschlag', 6091157, 0 ] );
push( @stations, [ 355, 250, 20, 'Im Stadtwald',     6091035, 0 ] );
push( @stations, [ 322, 111, 20, 'Justizzentrum',    1936,    7312000 ] );
push( @stations, [ 343, 44, 20, 'Jüdische Kultusgemeinde', 2028, 7312000 ] );
push( @stations, [ 216, 27,  20, 'Kammgarnstr.', 6091167, 0 ] );
push( @stations, [ 433, 137, 20, 'Kantstr.',     6091168, 0 ] );
push( @stations,
    [ 364, 22, 20, 'Katasteramt (Behördenhaus)', 1915, 7312000 ] );
push( @stations, [ 18,  55, 20, 'Kennelgarten Bahnhof', 6008127, 0 ] );
push( @stations, [ 281, 96, 20, 'Kessler-Handorn-Heim', 1847,    7312000 ] );
push( @stations, [ 336, 22, 20, 'Kino Central',         1785,    7312000 ] );
push( @stations, [ 345, 160, 20, 'Kirche des Nazareners', 1998, 7312000 ] );
push( @stations, [ 59,  260, 20, 'Konrad-Adenauer-Str.', 6091176, 0 ] );
push( @stations, [ 209, 11,  20, 'Kottenschule',         1772,    7312000 ] );
push( @stations, [ 217, 40,  20, 'Krankenhaus',          6091177, 0 ] );
push( @stations,
    [ 236, 38, 20, 'Kriminalpolizei (Pfaffplatz)', 1940, 7312000 ] );
push( @stations, [ 361, 10, 20, 'Kulturamt', 6006213, 0 ] );
push( @stations, [ 364, 22, 20, 'Kulturamt (Behördenhaus)', 1919, 7312000 ] );
push( @stations, [ 340, 237, 20, 'Kurpfalz-Realschule',  1773,    7312000 ] );
push( @stations, [ 307, 174, 20, 'Kurpfalzstr.',         6091182, 0 ] );
push( @stations, [ 63,  308, 20, 'Kurt-Schumacher-Str.', 6091183, 0 ] );
push( @stations, [ 96,  24,  20, 'Käthe-Kollwitz-Str.',  6091184, 0 ] );
push( @stations, [ 75,  102, 20, 'LBB (Bauamt)',         1920,    7312000 ] );
push( @stations, [ 353, 84,  20, 'LSV (Verkehrsamt)',    1921,    7312000 ] );
push( @stations,
    [ 364, 43, 20, 'Landesversicherungsanst. (LVA)', 1922, 7312000 ] );
push( @stations, [ 405, 26, 20, 'Landeszentralbank (LZB)', 1923, 7312000 ] );
push( @stations,
    [ 322, 111, 20, 'Landgericht (Justizzentr.)', 1939, 7312000 ] );
push( @stations, [ 385, 180, 20, 'Lassallestr.',         6091192, 0 ] );
push( @stations, [ 405, 212, 20, 'Leibnitzstr.',         6091193, 0 ] );
push( @stations, [ 31,  195, 20, 'Leipziger Str.',       6091195, 0 ] );
push( @stations, [ 36,  15,  20, 'Lothringer Dell',      6091202, 0 ] );
push( @stations, [ 111, 49,  20, 'Lothringer Eck',       6091203, 0 ] );
push( @stations, [ 40,  315, 20, 'Ludwig-Erhard-Str.',   6091204, 0 ] );
push( @stations, [ 442, 25,  20, 'Lutherkirche',         2008,    7312000 ] );
push( @stations, [ 348, 49,  20, 'Lutrinaklinik',        1879,    7312000 ] );
push( @stations, [ 434, 41,  20, 'Maria-Schutz Kirche',  2009,    7312000 ] );
push( @stations, [ 83,  272, 20, 'Marie-Juchacz-Str.',   6091208, 0 ] );
push( @stations, [ 261, 49,  20, 'Marienkirche',         6006211, 0 ] );
push( @stations, [ 329, 27,  20, 'Marktstr.',            6091210, 0 ] );
push( @stations, [ 364, 1,   20, 'Medienzentrum (MZKL)', 1713,    7312000 ] );
push( @stations, [ 358, 84, 20, 'Medizinisches Zentrum', 1880,    7312000 ] );
push( @stations, [ 371, 46, 20, 'Mennonitenkirche',      2010,    7312000 ] );
push( @stations, [ 437, 24, 20, 'Messeplatz',            6091217, 0 ] );
push( @stations,
    [ 209, 132, 20, 'Neuap. Kirche, Pirmas. Str.', 2013, 7312000 ] );
push( @stations, [ 59,  77,  20, 'Neue Brücke',       6091218, 0 ] );
push( @stations, [ 129, 269, 20, 'Newhamstr.',        6091227, 0 ] );
push( @stations, [ 65,  86,  20, 'Pariser Str.',      6091237, 0 ] );
push( @stations, [ 308, 94,  20, 'Parkstr.',          6091244, 0 ] );
push( @stations, [ 416, 226, 20, 'Pascalstr.',        6091245, 0 ] );
push( @stations, [ 368, 81,  20, 'Paul-Münch-Schule', 1776,    7312000 ] );
push( @stations, [ 301, 174, 20, 'Pauluskirche',      1991,    7312000 ] );
push( @stations, [ 223, 261, 20, 'Pestalozzischule',  1777,    7312000 ] );
push( @stations, [ 230, 265, 20, 'Pestalozzischule',  6091247, 0 ] );
push( @stations, [ 121, 108, 20, 'Pfaffbrücke',       6091248, 0 ] );
push( @stations, [ 243, 183, 20, 'Pfaffenbergstr.',   6091249, 0 ] );
push( @stations, [ 234, 24,  20, 'Pfaffpl./Pariser Str.',  6091282, 0 ] );
push( @stations, [ 238, 28,  20, 'Pfaffplatz',             6006221, 0 ] );
push( @stations, [ 234, 24,  20, 'Pfaffplatz/Pariserstr.', 6006226, 0 ] );
push( @stations, [ 104, 163, 20, 'Pfaffsiedlung',          6091117, 0 ] );
push( @stations, [ 214, 96,  20, 'Pfaffstr.',              6091116, 0 ] );
push( @stations, [ 171, 139, 20, 'Pfaffwerk',              6008020, 0 ] );
push( @stations, [ 195, 122, 20, 'Pfaffwerk Haupttor',     6006231, 0 ] );
push( @stations, [ 370, 25, 20, 'Pfalzbibliothek',         1883, 7312000 ] );
push( @stations, [ 197, 85, 20, 'Pfalzklinik-Tagesklinik', 5049, 7312000 ] );
push( @stations, [ 266, 67, 20, 'Pirmasenser Str.', 6091251, 0 ] );
push( @stations,
    [ '374', '-1', '20', 'Polizei (Gaustr.)', '1941', '7312000' ] );
push( @stations, [ 345, 108, 20, 'Polizeipräsidium', 6091252, 0 ] );
push( @stations, [ 335, 110, 20, 'Polizeipräsidium', 1942,    7312000 ] );
push( @stations, [ 296, 110, 20, 'Post',             6091233, 0 ] );
push( @stations, [ 74,  114, 20, 'Rauschenweg',      6091255, 0 ] );
push( @stations, [ 296, 56,  20, 'Rosenstr.',        6091258, 0 ] );
push( @stations, [ 442, 182, 20, 'Rousseaustr.',     6091257, 0 ] );
push( @stations, [ 222, 63,  20, 'Rundbau',          6091260, 0 ] );
push( @stations, [ 275, 57,  20, 'Röhmschule',       1778,    7312000 ] );
push( @stations,
    [ 91, 109, 20, 'SOS-Kinder- u. Jugendhilfe', 1878, 7312000 ] );
push( @stations,
    [ 74, 117, 20, 'Sammelplunkt Stresemannschule', 6091298, 0 ] );
push( @stations, [ 326, 3,   20, 'Schillerplatz',    6091178, 0 ] );
push( @stations, [ 114, 0,   20, 'Schillerschule',   1779,    7312000 ] );
push( @stations, [ 343, 249, 20, 'Schulzentrum Süd', 1870,    7312000 ] );
push( @stations, [ 360, 226, 20, 'Schulzentrum Süd', 6091264, 0 ] );
push( @stations, [ 286, 6, 20, 'Seniorenheim KL-Mitte', 1848, 7312000 ] );
push( @stations, [ 10,  150, 20, 'Sickinger Str.', 6091277, 0 ] );
push( @stations, [ 332, 12,  20, 'Spinnrädl',      1947,    7312000 ] );
push( @stations, [ 449, 213, 20, 'Spinozastr.',    6091262, 0 ] );
push( @stations,
    [ 34, 42, 20, 'Sportanlage Reichswaldstr.', 1963, 7312000 ] );
push( @stations, [ 174, 240, 20, 'Sportanlage Universität', 1965, 7312000 ] );
push( @stations,
    [ 412, 145, 20, 'Sportplatz Fritz-Walter-Str.', 1968, 7312000 ] );
push( @stations,
    [ 72, 196, 20, 'Sportplatz Hohenecker Str.', 1970, 7312000 ] );
push( @stations, [ 361, 198, 20, 'Sprangerstr.', 6091286, 0 ] );
push( @stations, [ 416, 206, 20, 'St. Franziskus Kirche', 2017, 7312000 ] );
push( @stations,
    [ 446, 53, 20, 'St. Hedwigs-Heim (Caritas)', 1875, 7312000 ] );
push( @stations, [ 78,  44,  20, 'St. Konrad Kirche',     2019, 7312000 ] );
push( @stations, [ 257, 48,  20, 'St. Marien Kirche',     1949, 7312000 ] );
push( @stations, [ 350, 0,   20, 'St. Martin Kirche',     1950, 7312000 ] );
push( @stations, [ 52,  278, 20, 'St. Theresia Kirche',   2025, 7312000 ] );
push( @stations, [ 273, 25,  20, 'St.-Franziskus-Schule', 1780, 7312000 ] );
push( @stations, [ 434, 212, 20, 'Stephanuskirche',       2016, 7312000 ] );
push( @stations, [ 339, 16,  20, 'Stiftskirche',          1948, 7312000 ] );
push( @stations, [ 358, 8,   20, 'Stiftsplatz',      6091291, 0 ] );
push( @stations, [ 59,  115, 20, 'Stresemannschule', 6091295, 0 ] );
push( @stations, [ 65,  117, 20, 'Stresemannschule', 1782,    7312000 ] );
push( @stations,
    [ 175, 272, 20, 'Technische Universität (TU)', 1722, 7312000 ] );
push( @stations, [ 290, 0, 20, 'Technische Werke KL (TWK)', 1933, 7312000 ] );
push( @stations,
    [ 144, 288, 20, 'Tennishalle Trippstadter Str.', 2096, 7312000 ] );
push( @stations,
    [ 280, 244, 20, 'Tennisplatz Lämmchesberg', 1975, 7312000 ] );
push( @stations,
    [ 141, 299, 20, 'Tennisplatz Trippstadter Str.', 2095, 7312000 ] );
push( @stations, [ 104, 235, 20, 'Theodor-Heuss-Str.', 6091299, 0 ] );
push( @stations, [ 91,  121, 20, 'Triftstr.',          6091306, 0 ] );
push( @stations, [ 274, 117, 20, 'Trippstadter Str.',  6091234, 0 ] );
push( @stations, [ 200, 275, 20, 'Uni Ost',            6091310, 0 ] );
push( @stations, [ 167, 254, 20, 'Uni Sporthalle',     6091311, 0 ] );
push( @stations, [ 167, 290, 20, 'Uni Süd',            6091312, 0 ] );
push( @stations, [ 311, 45,  20, 'Union-Kino',         1787,    7312000 ] );
push( @stations,
    [ 172, 263, 20, 'Universitätsbibliothek (UB)', 1885, 7312000 ] );
push( @stations,
    [ 261, 89, 20, 'Verbandsgemeindeverw. KL-Süd', 1934, 7312000 ] );
push( @stations, [ 3,  151, 20, 'Versöhnungskirche', 2027,    7312000 ] );
push( @stations, [ 11, 5,   20, 'Vogelwoogstr.',     6091324, 0 ] );
push( @stations, [ 364, 1, 20, 'Volkshochschule (VHS)', 1719, 7312000 ] );
push( @stations, [ 338, 151, 20, 'Waldschlößchen',     6091265, 0 ] );
push( @stations, [ 166, 35,  20, 'Waldstr.',           6091325, 0 ] );
push( @stations, [ 228, 199, 20, 'Walter-Flex-Str.',   6091326, 0 ] );
push( @stations, [ 216, 53,  20, 'Westpfalz-Klinikum', 1882,    7312000 ] );
push( @stations, [ 385, 51,  20, 'Wilhelmsplatz',      6091314, 0 ] );
push( @stations, [ 260, 61,  20, 'Ziegelstr.',         6091275, 0 ] );

@stations = ();

#.area.shape..circle..coords..([\-\d]*),(\d*),(\d*)..alt..(.*)..href..javascript:setOdvResultClickMap..*.,.(\d*).,.(\d*).....
#push\(@stations,\ \[$1,$2,$3,\'$4\',$5,$6\]\)\;
push( @stations, [ 249, 59,  20, 'Am Belzappel',        6091356,  0 ] );
push( @stations, [ 444, 209, 20, 'Am Harzhübel',        6091016,  0 ] );
push( @stations, [ 242, 18,  20, 'Ausbesserungswerk',   80021047, 0 ] );
push( @stations, [ 324, 49,  20, 'Bahnheim',            6091027,  0 ] );
push( @stations, [ 290, 53,  20, 'Bahnheim West',       6091028,  0 ] );
push( @stations, [ 257, 147, 20, 'Bännjerrückschule',   1724,     7312000 ] );
push( @stations, [ 422, 40,  20, 'DRK-Seniorenzentrum', 1844,     7312000 ] );
push( @stations, [ 347, 126, 20, 'Damaschkestr.',       6091049,  0 ] );
push( @stations, [ 430, 217, 20, 'Davenportplatz',      6091054,  0 ] );
push( @stations, [ 239, 128, 20, 'Dresdener Str.',      6091059,  0 ] );
push( @stations, [ 335, 51,  20, 'Eichamt',             1907,     7312000 ] );
push( @stations, [ 421, 49,  20, 'Feuerwache',          6091348,  0 ] );
push( @stations, [ 395, 45,  20, 'Feuerwache',          1908,     7312000 ] );
push( @stations, [ 370, 245, 20, 'Friedenskirche',      1994,     7312000 ] );
push( @stations, [ 272, 156, 20, 'Fritz-Walter-Schule', 1762,     7312000 ] );
push( @stations, [ 16,  284, 20, 'Fußgängertunnel',     6091096,  0 ] );
push( @stations, [ 414, 93,  20, 'Galgenschanze Bahnhof', 6008186, 0 ] );
push( @stations, [ 153, 9,   20, 'Gewerbegebiet West',    6091106, 0 ] );
push( @stations, [ 76,  259, 20, 'Grüne Dell',            6091112, 0 ] );
push( @stations, [ 446, 120, 20, 'Gusswerk',              6091113, 0 ] );
push( @stations, [ 266, 112, 20, 'Hallesche Str.',        6091125, 0 ] );
push( @stations, [ 293, 111, 20, 'Heilig Kreuz Kirche',  1996,    7312000 ] );
push( @stations, [ 52,  303, 20, 'Hohenecken Bahnhof',   6091103, 0 ] );
push( @stations, [ 106, 271, 20, 'Hohenecken Ost',       6091139, 0 ] );
push( @stations, [ 368, 143, 20, 'Hohenecker Str.',      6091118, 0 ] );
push( @stations, [ 197, 56,  20, 'Homburger Str.',       6091141, 0 ] );
push( @stations, [ 5,   324, 20, 'Im Kunzental',         6091158, 0 ] );
push( @stations, [ 324, 20,  20, 'Kennelgarten Bahnhof', 6008127, 0 ] );
push( @stations, [ 186, 7,   20, 'Kfz-Zulassungsstelle', 1916,    7312000 ] );
push( @stations, [ 365, 224, 20, 'Konrad-Adenauer-Str.', 6091176, 0 ] );
push( @stations, [ 369, 273, 20, 'Kurt-Schumacher-Str.', 6091183, 0 ] );
push( @stations, [ 382, 67,  20, 'LBB (Bauamt)',         1920,    7312000 ] );
push( @stations, [ 338, 161, 20, 'Leipziger Str.',       6091195, 0 ] );
push( @stations, [ 42,  256, 20, 'Lerchenstr.',          6091196, 0 ] );
push( @stations, [ 418, 14,  20, 'Lothringer Eck',       6091203, 0 ] );
push( @stations, [ 347, 279, 20, 'Ludwig-Erhard-Str.',   6091204, 0 ] )
    ;    #408362 // 5475014
push( @stations, [ 252, 73,  20, 'Lukaskirche',        2007,    7312000 ] );
push( @stations, [ 390, 237, 20, 'Marie-Juchacz-Str.', 6091208, 0 ] );
push( @stations, [ 267, 154, 20, 'Merseburger Str.',   6091215, 0 ] );
push( @stations, [ 365, 42,  20, 'Neue Brücke',        6091218, 0 ] );
push( @stations, [ 435, 233, 20, 'Newhamstr.',         6091227, 0 ] );
push( @stations, [ 11,  262, 20, 'Oberwald',           6091228, 0 ] );
push( @stations, [ 97,  16,  20, 'Opelkreisel',        6091224, 0 ] )
    ;    #406262 // 5477255
push( @stations, [ 371, 51,  20, 'Pariser Str.',  6091237, 0 ] );
push( @stations, [ 428, 73,  20, 'Pfaffbrücke',   6091248, 0 ] );
push( @stations, [ 410, 128, 20, 'Pfaffsiedlung', 6091117, 0 ] );
push( @stations, [ 131, 54,  20, 'RSW Vogelweh',  6091343, 0 ] );
push( @stations, [ 380, 79,  20, 'Rauschenweg',   6091255, 0 ] );
push( @stations,
    [ 397, 74, 20, 'SOS-Kinder- u. Jugendhilfe', 1878, 7312000 ] );
push( @stations,
    [ 380, 81, 20, 'Sammelplunkt Stresemannschule', 6091298, 0 ] );
push( @stations, [ 316, 115, 20, 'Sickinger Str.', 6091277, 0 ] );
push( @stations, [ -6, 235, 20, 'Sportanlage Hohenecken', 1959, 7312000 ] );
push( @stations,
    [ 341, 7, 20, 'Sportanlage Reichswaldstr.', 1963, 7312000 ] );
push( @stations,
    [ 378, 162, 20, 'Sportplatz Hohenecker Str.', 1970, 7312000 ] );
push( @stations, [ 384, 9,   20, 'St. Konrad Kirche',   2019,    7312000 ] );
push( @stations, [ 358, 242, 20, 'St. Theresia Kirche', 2025,    7312000 ] );
push( @stations, [ 365, 80,  20, 'Stresemannschule',    6091295, 0 ] );
push( @stations, [ 372, 82,  20, 'Stresemannschule',    1782,    7312000 ] );
push( @stations,
    [ 451, 253, 20, 'Tennishalle Trippstadter Str.', 2096, 7312000 ] );
push( @stations,
    [ 448, 264, 20, 'Tennisplatz Trippstadter Str.', 2095, 7312000 ] );
push( @stations, [ 410, 199, 20, 'Theodor-Heuss-Str.', 6091299, 0 ] );
push( @stations, [ 397, 86,  20, 'Triftstr.',          6091306, 0 ] );
push( @stations, [ 179, 10,  20, 'TÜV',                1841,    7312000 ] );
push( @stations, [ 179, 10, 20, 'TÜV-Akademie Rheinland', 1718, 7312000 ] );
push( @stations, [ 223, 235, 20, 'US Wohnung',        6091308, 0 ] );
push( @stations, [ 309, 116, 20, 'Versöhnungskirche', 2027,    7312000 ] );
push( @stations, [ 72,  52,  20, 'Vogelweh',          6008126, 0 ] );
push( @stations, [ 127, 56,  20, 'Vogelweh Ost',      6091319, 0 ] );
push( @stations, [ 108, 66,  20, 'Vogelweh Süd',      6091320, 0 ] );
push( @stations, [ 107, 60,  20, 'Vogelweh West',     6091321, 0 ] );

@stations = ();
push( @stations, [ 413, 71,  20, '23er Kaserne',        6091001, 0 ] );
push( @stations, [ 98,  135, 20, 'Addi-Schaurer-Platz', 6091232, 0 ] );
push( @stations, [ 177, 135, 20, 'Agentur für Arbeit',  1903,    7312000 ] );
push( @stations,
    [ 135, 18, 20, 'Albert-Schweitzer-Gymnasium', 1723, 7312000 ] );
push( @stations, [ 213, 75, 20, 'Albrechtstr.', 6006214, 0 ] );
push( @stations, [ 411, -5, 20, 'Alex-Müller-Heim (AWO)', 1842, 7312000 ] );
push( @stations, [ 151, 99, 20, 'Alleestr.',       6091007, 0 ] );
push( @stations, [ 165, 18, 20, 'Alte Stadtmauer', 6091361, 0 ] );
push( @stations, [ 283, 57, 20, 'Altenwoogstr.',   6091010, 0 ] );
push( @stations, [ 259, 20, 20, 'Alter Friedhof',  6091011, 0 ] );
push( @stations,
    [ 168, 39, 20, 'Altstadttheater E.-Stein-Haus', 1892, 7312000 ] );
push( @stations,
    [ 135, 158, 20, 'Amtsgericht (Justizzentr.)', 1937, 7312000 ] );
push( @stations, [ 71,  63,  20, 'Apostelkirche', 1987,    7312000 ] );
push( @stations, [ 79,  66,  20, 'Apostelkirche', 6091019, 0 ] );
push( @stations, [ 187, 138, 20, 'Arbeitsamt',    6091020, 0 ] );
push( @stations,
    [ 135, 158, 20, 'Arbeitsgericht (Justizzentr.)', 1938, 7312000 ] );
push( @stations,
    [ 189, 24, 20, 'Atlantische Akademie R.-P.', 1705, 7312000 ] );
push( @stations,
    [ 175, 304, 20, 'Ausbildungszentr. der HWK', 1706, 7312000 ] );
push( @stations, [ 49,  225, 20, 'Balbierstr.',      6091030, 0 ] );
push( @stations, [ 18,  261, 20, 'Barbarossahalle',  1894,    7312000 ] );
push( @stations, [ 204, 119, 20, 'Barbarossaschule', 1725,    7312000 ] );
push( @stations, [ 221, 126, 20, 'Barbarossastr.',   6091032, 0 ] );
push( @stations, [ 177, 68,  20, 'Behördenhaus',     1904,    7312000 ] );
push( @stations, [ 113, 66, 20, 'Benedict-Sprachschule', 1707,    7312000 ] );
push( @stations, [ 127, 16, 20, 'Benzinoring',           6091358, 0 ] );
push( @stations,
    [ 156, 296, 20, 'Bertha-v.-Suttner-Ges.schule', 1727, 7312000 ] );
push( @stations, [ 147, 13, 20, 'Berufsbildende Schule II', 1758, 7312000 ] );
push( @stations, [ 233, 239, 20, 'Betzenberg',          6091036, 0 ] );
push( @stations, [ 226, 265, 20, 'Betzenbergschule',    1759,    7312000 ] );
push( @stations, [ 159, 67,  20, 'BfA',                 1905,    7312000 ] );
push( @stations, [ 165, 71,  20, 'Bismarckstr.',        6009050, 0 ] );
push( @stations, [ 65,  177, 20, 'Blücherstr. Abzw.',   6091148, 0 ] );
push( @stations, [ 33,  263, 20, 'Buchenlochstr.',      6091043, 0 ] );
push( @stations, [ 104, 44,  20, 'Burgstr.',            6091149, 0 ] );
push( @stations, [ 88,  230, 20, 'Casimirring Nord',    6091046, 0 ] );
push( @stations, [ 104, 243, 20, 'Casimirring Süd',     6091047, 0 ] );
push( @stations, [ 130, 43,  20, 'Casimirsaal',         1896,    7312000 ] );
push( @stations, [ 98,  231, 20, 'Christ-König Kirche', 1990,    7312000 ] );
push( @stations, [ 303, 29,  20, 'Christuskirche',      1992,    7312000 ] );
push( @stations, [ 268, 117, 20, 'DEKRA-Akademie',      1709,    7312000 ] );
push( @stations, [ 24,  202, 20, 'Dammstr.',            6091050, 0 ] );
push( @stations, [ 319, 58,  20, 'Daniel-Häberle-Str.', 6091051, 0 ] );
push( @stations,
    [ 124, 22, 20, 'Deutsch-amerikan. Bürgerbüro', 1906, 7312000 ] );
push( @stations,
    [ 192, 130, 20, 'Deutsches Rotes Kreuz (DRK)', 1837, 7312000 ] );
push( @stations, [ 62,  125, 20, 'Diakonissenheim', 1873, 7312000 ] );
push( @stations, [ 241, 230, 20, 'Dorimare',        1830, 7312000 ] );
push( @stations,
    [ 160, 67, 20, 'Dt. Angestellten-Akad. (DAA)', 1710, 7312000 ] );
push( @stations, [ 155, 228, 20, 'Dunkeltälchen', 6091060, 0 ] );
push( @stations, [ 73,  181, 20, 'E-Werk',        6091062, 0 ] );
push( @stations, [ 237, 149, 20, 'Erbsenberg',    6091274, 0 ] );
push( @stations, [ 270, 157, 20, 'Erbsenbergsportanlage', 2094, 7312000 ] );
push( @stations,
    [ 293, 27, 20, 'Evang. Kinder- u. Jugendheim', 1877, 7312000 ] );
push( @stations, [ 49, 25, 20, 'Fachhochschule II (FH)', 1721, 7312000 ] );
push( @stations, [ 117, 58,  20, 'Fackelbrunnen',      6091169, 0 ] );
push( @stations, [ 108, 71,  20, 'Fackelpassage',      6091302, 0 ] );
push( @stations, [ 99,  75,  20, 'Fackelwoogstr.',     6091091, 0 ] );
push( @stations, [ 71,  41,  20, 'Fillmore Musichall', 1784,    7312000 ] );
push( @stations, [ 158, 139, 20, 'Finanzamt',          6009041, 0 ] );
push( @stations, [ 154, 133, 20, 'Finanzamt',          1909,    7312000 ] );
push( @stations,
    [ 157, 118, 20, 'Fortbild.akad. Wirtsch. (FAW)', 1711, 7312000 ] );
push( @stations, [ 93, 74, 20, 'Franziskanerinnen Kapelle', 1993, 7312000 ] );
push( @stations, [ 352, 63, 20, 'Friedhof', 6006225, 0 ] );
push( @stations, [ 377, 25, 20, 'Friedhof Eingang West', 6091304, 0 ] )
    ;    #412870 // 5477949
push( @stations,
    [ 199, 196, 20, 'Fritz-Walter-Stadion', 2147003013, 7312000 ] );
push( @stations, [ 142, 47,  20, 'Fruchthalle',        1897,    7312000 ] );
push( @stations, [ -6,  0,   20, 'Gartenschau',        1826,    7312000 ] );
push( @stations, [ 2,   124, 20, 'Gesundheitsamt',     1911,    7312000 ] );
push( @stations, [ 3,   98,  20, 'Goetheschule',       6091107, 0 ] );
push( @stations, [ 6,   107, 20, 'Goetheschule (IGS)', 1764,    7312000 ] );
push( @stations, [ 44,  133, 20, 'Graviusheim',        1874,    7312000 ] );
push( @stations, [ 370, 32,  20, 'Grünflächenamt',     1912,    7312000 ] );
push( @stations, [ 156, 23, 20, 'Gymnasium am Rittersberg', 1766, 7312000 ] );
push( @stations,
    [ 110, 38, 20, 'Gymnasium an der Burgstr.', 1767, 7312000 ] );
push( @stations,
    [ 131, 68, 20, 'Handwerkskammer der Pfalz', 1838, 7312000 ] );
push( @stations, [ 53,  113, 20, 'Hartmannstr.',  6091115, 0 ] );
push( @stations, [ 130, 166, 20, 'Hauptbahnhof',  6009035, 0 ] );
push( @stations, [ 420, 39,  20, 'Hauptfriedhof', 1985,    7312000 ] );
push( @stations, [ 229, 240, 20, 'Hegelstr.',     6091133, 0 ] );
push( @stations, [ 67, 287, 20, 'Heinrich-Heine-Gymnasium', 1769, 7312000 ] );
push( @stations, [ 54,  271, 20, 'Hermann-Löns-Str.',   6091126, 0 ] );
push( @stations, [ 74,  263, 20, 'Im Busch',            6091153, 0 ] );
push( @stations, [ 53,  259, 20, 'Im Kuckuckschlag',    6091157, 0 ] );
push( @stations, [ 168, 297, 20, 'Im Stadtwald',        6091035, 0 ] );
push( @stations, [ 95,  17,  20, 'Japanischer Garten',  1827,    7312000 ] );
push( @stations, [ 103, 29,  20, 'Jesu-Christi Kirche', 1997,    7312000 ] );
push( @stations,
    [ 182, 25, 20, 'Jugend- u. Programmzentr. (JUZ)', 1898, 7312000 ] );
push( @stations, [ 299, 123, 20, 'Jugendverkehrsschule',    1771, 7312000 ] );
push( @stations, [ 135, 158, 20, 'Justizzentrum',           1936, 7312000 ] );
push( @stations, [ 156, 91,  20, 'Jüdische Kultusgemeinde', 2028, 7312000 ] );
push( @stations, [ 124, 22, 20, 'KL Umweltberatung (KLUB)', 1914, 7312000 ] );
push( @stations, [ 200, 16, 20, 'Kaiserbrunnen', 1944, 7312000 ] );
push( @stations, [ 13,  18,  20, 'Kammgarn',     6091166, 0 ] );
push( @stations, [ 28,  74,  20, 'Kammgarnstr.', 6091167, 0 ] );
push( @stations, [ 245, 183, 20, 'Kantstr.',     6091168, 0 ] );
push( @stations,
    [ 177, 68, 20, 'Katasteramt (Behördenhaus)', 1915, 7312000 ] );
push( @stations, [ 94,  143, 20, 'Kessler-Handorn-Heim',  1847, 7312000 ] );
push( @stations, [ 149, 69,  20, 'Kino Central',          1785, 7312000 ] );
push( @stations, [ 159, 206, 20, 'Kirche des Nazareners', 1998, 7312000 ] );
push( @stations,
    [ 129, 36, 20, 'Kommunales Studieninst. (KSI)', 1712, 7312000 ] );
push( @stations, [ 21,  57, 20, 'Kottenschule',    1772,    7312000 ] );
push( @stations, [ 29,  86, 20, 'Krankenhaus',     6091177, 0 ] );
push( @stations, [ 111, 25, 20, 'Kreisverwaltung', 6091357, 0 ] );
push( @stations, [ 121, 18, 20, 'Kreisverwaltung', 1917,    7312000 ] );
push( @stations,
    [ 49, 85, 20, 'Kriminalpolizei (Pfaffplatz)', 1940, 7312000 ] );
push( @stations, [ 175, 57, 20, 'Kulturamt', 6006213, 0 ] );
push( @stations, [ 177, 68, 20, 'Kulturamt (Behördenhaus)', 1919, 7312000 ] );
push( @stations, [ 27,  22, 20, 'Kulturzentrum Kammgarn',   1900, 7312000 ] );
push( @stations, [ 153, 284, 20, 'Kurpfalz-Realschule', 1773,    7312000 ] );
push( @stations, [ 120, 221, 20, 'Kurpfalzstr.',        6091182, 0 ] );
push( @stations, [ 166, 131, 20, 'LSV (Verkehrsamt)',   1921,    7312000 ] );
push( @stations,
    [ 178, 90, 20, 'Landesversicherungsanst. (LVA)', 1922, 7312000 ] );
push( @stations, [ 219, 72, 20, 'Landeszentralbank (LZB)', 1923, 7312000 ] );
push( @stations,
    [ 135, 158, 20, 'Landgericht (Justizzentr.)', 1939, 7312000 ] );
push( @stations, [ 198, 227, 20, 'Lassallestr.',         6091192, 0 ] );
push( @stations, [ 218, 259, 20, 'Leibnitzstr.',         6091193, 0 ] );
push( @stations, [ 435, 150, 20, 'Licht-Luft',           6091339, 0 ] );
push( @stations, [ 199, 11,  20, 'Ludwigstr.',           6091362, 0 ] );
push( @stations, [ 220, 42,  20, 'Luitpoldschule',       1775,    7312000 ] );
push( @stations, [ 254, 72,  20, 'Lutherkirche',         2008,    7312000 ] );
push( @stations, [ 161, 96,  20, 'Lutrinaklinik',        1879,    7312000 ] );
push( @stations, [ 203, 15,  20, 'Mainzer Tor',          6091206, 0 ] );
push( @stations, [ 226, 38,  20, 'Mannheimer Str.',      6091207, 0 ] );
push( @stations, [ 246, 87,  20, 'Maria-Schutz Kirche',  2009,    7312000 ] );
push( @stations, [ 74,  96,  20, 'Marienkirche',         6006211, 0 ] );
push( @stations, [ 143, 73,  20, 'Marktstr.',            6091210, 0 ] );
push( @stations, [ 142, 8,   20, 'Martin-Luther-Str.',   6091211, 0 ] );
push( @stations, [ 226, 1,   20, 'Max und Moritz',       6091216, 0 ] );
push( @stations, [ 116, 36,  20, 'Maxstr.',              6091212, 0 ] );
push( @stations, [ 177, 48,  20, 'Medienzentrum (MZKL)', 1713,    7312000 ] );
push( @stations, [ 171, 131, 20, 'Medizinisches Zentrum', 1880, 7312000 ] );
push( @stations, [ 184, 93,  20, 'Mennonitenkirche',      2010, 7312000 ] );
push( @stations, [ 249, 70, 20, 'Messeplatz',        6091217, 0 ] );
push( @stations, [ 408, 96, 20, 'Methodistenkirche', 2011,    7312000 ] );
push( @stations, [ 157, 41, 20, 'Musikschule',       1715,    7312000 ] );
push( @stations, [ 69,  32, 20, 'Mühlstr.',          6091223, 0 ] );
push( @stations,
    [ 21, 178, 20, 'Neuap. Kirche, Pirmas. Str.', 2013, 7312000 ] );
push( @stations, [ 121, 141, 20, 'Parkstr.',          6091244, 0 ] );
push( @stations, [ 228, 272, 20, 'Pascalstr.',        6091245, 0 ] );
push( @stations, [ 181, 128, 20, 'Paul-Münch-Schule', 1776,    7312000 ] );
push( @stations, [ 114, 221, 20, 'Pauluskirche',      1991,    7312000 ] );
push( @stations, [ 36,  308, 20, 'Pestalozzischule',  1777,    7312000 ] );
push( @stations, [ 43,  311, 20, 'Pestalozzischule',  6091247, 0 ] );
push( @stations, [ 57,  229, 20, 'Pfaffenbergstr.',   6091249, 0 ] );
push( @stations, [ 48, 70,  20, 'Pfaffpl./Pariser Str.',  6091282, 0 ] );
push( @stations, [ 51, 75,  20, 'Pfaffplatz',             6006221, 0 ] );
push( @stations, [ 47, 70,  20, 'Pfaffplatz/Pariserstr.', 6006226, 0 ] );
push( @stations, [ 26, 143, 20, 'Pfaffstr.',              6091116, 0 ] );
push( @stations, [ 7,  168, 20, 'Pfaffwerk Haupttor',     6006231, 0 ] );
push( @stations, [ 183, 72,  20, 'Pfalzbibliothek',         1883, 7312000 ] );
push( @stations, [ 130, 1,   20, 'Pfalzgalerie',            1889, 7312000 ] );
push( @stations, [ 9,   132, 20, 'Pfalzklinik-Tagesklinik', 5049, 7312000 ] );
push( @stations, [ 138, 29,  20, 'Pfalztheater',            1893, 7312000 ] );
push( @stations, [ 79,  114, 20, 'Pirmasenser Str.',  6091251, 0 ] );
push( @stations, [ 188, 44,  20, 'Polizei (Gaustr.)', 1941,    7312000 ] );
push( @stations, [ 148, 156, 20, 'Polizeipräsidium',  1942,    7312000 ] );
push( @stations, [ 158, 155, 20, 'Polizeipräsidium',  6091252, 0 ] );
push( @stations, [ 110, 157, 20, 'Post',              6091233, 0 ] );
push( @stations, [ 131, 46,  20, 'Rathaus',           6006220, 0 ] );
push( @stations,
    [ 126, 33, 20, 'Rathaus / Stadtverwaltung', 1931, 7312000 ] );
push( @stations, [ 109, 103, 20, 'Rosenstr.',        6091258, 0 ] );
push( @stations, [ 254, 229, 20, 'Rousseaustr.',     6091257, 0 ] );
push( @stations, [ 34,  110, 20, 'Rundbau',          6091260, 0 ] );
push( @stations, [ 88,  104, 20, 'Röhmschule',       1778,    7312000 ] );
push( @stations, [ 140, 50,  20, 'Schillerplatz',    6091178, 0 ] );
push( @stations, [ 156, 296, 20, 'Schulzentrum Süd', 1870,    7312000 ] );
push( @stations, [ 174, 273, 20, 'Schulzentrum Süd', 6091264, 0 ] );
push( @stations, [ 99,  53, 20, 'Seniorenheim KL-Mitte', 1848, 7312000 ] );
push( @stations, [ 146, 58, 20, 'Spinnrädl',             1947, 7312000 ] );
push( @stations, [ 261, 260, 20, 'Spinozastr.', 6091262, 0 ] );
push( @stations,
    [ 393, 142, 20, 'Sportanlage Entersweilerstr.', 1960, 7312000 ] );
push( @stations, [ 303, 139, 20, 'Sportanlage Kniebrech', 1955, 7312000 ] );
push( @stations,
    [ 225, 191, 20, 'Sportplatz Fritz-Walter-Str.', 1968, 7312000 ] );
push( @stations, [ 175, 244, 20, 'Sprangerstr.', 6091286, 0 ] );
push( @stations, [ 228, 253, 20, 'St. Franziskus Kirche', 2017, 7312000 ] );
push( @stations,
    [ 258, 99, 20, 'St. Hedwigs-Heim (Caritas)', 1875, 7312000 ] );
push( @stations, [ 70,  95, 20, 'St. Marien Kirche',        1949, 7312000 ] );
push( @stations, [ 164, 46, 20, 'St. Martin Kirche',        1950, 7312000 ] );
push( @stations, [ 319, 3,  20, 'St. Norbert Kirche',       2021, 7312000 ] );
push( @stations, [ 86,  72, 20, 'St.-Franziskus-Schule',    1780, 7312000 ] );
push( @stations, [ 126, 33, 20, 'Stadtarchiv (im Rathaus)', 1932, 7312000 ] );
push( @stations, [ 175, 43, 20, 'Stadtbibliothek',          1884, 7312000 ] );
push( @stations, [ 247, 259, 20, 'Stephanuskirche', 2016, 7312000 ] );
push( @stations, [ 152, 63,  20, 'Stiftskirche',    1948, 7312000 ] );
push( @stations,
    [ 156, 33, 20, 'Stiftskirche, Kleine Kirche', 2018, 7312000 ] );
push( @stations, [ 171, 55,  20, 'Stiftsplatz',      6091291, 0 ] );
push( @stations, [ 382, 103, 20, 'Stiftswaldschule', 1781,    7312000 ] );
push( @stations, [ 411, 92,  20, 'Stiftswaldstr.',   6091292, 0 ] );
push( @stations,
    [ 52, 32, 20, 'Technische Akad. Südw. (TAS)', 1717, 7312000 ] );
push( @stations,
    [ -13, 319, 20, 'Technische Universität (TU)', 1722, 7312000 ] );
push( @stations,
    [ 104, 47, 20, 'Technische Werke KL (TWK)', 1933, 7312000 ] );
push( @stations,
    [ 443, 157, 20, 'Tennisplatz Entersweilerstr.', 1972, 7312000 ] );
push( @stations, [ 93, 291, 20, 'Tennisplatz Lämmchesberg', 1975, 7312000 ] );
push( @stations, [ 191, 26,  20, 'Theodor-Zink-Museum', 1890,    7312000 ] );
push( @stations, [ 87,  163, 20, 'Trippstadter Str.',   6091234, 0 ] );
push( @stations, [ 12, 321, 20, 'Uni Ost', 6091310, 0 ] );  #409703 // 5475313
push( @stations, [ 124, 91, 20, 'Union-Kino', 1787, 7312000 ] );
push( @stations,
    [ 74, 136, 20, 'Verbandsgemeindeverw. KL-Süd', 1934, 7312000 ] );
push( @stations, [ 177, 48,  20, 'Volkshochschule (VHS)', 1719, 7312000 ] );
push( @stations, [ 344, 107, 20, 'Volkspark',             1828, 7312000 ] );
push( @stations, [ 271, 244, 20, 'Voltairestr.',       6091261, 0 ] );
push( @stations, [ 187, 19,  20, 'Wadgasserhof',       1891,    7312000 ] );
push( @stations, [ 151, 197, 20, 'Waldschlößchen',     6091265, 0 ] );
push( @stations, [ 41,  245, 20, 'Walter-Flex-Str.',   6091326, 0 ] );
push( @stations, [ 390, 126, 20, 'Warmfreibad',        6091327, 0 ] );
push( @stations, [ 379, 127, 20, 'Warmfreibad',        1834,    7312000 ] );
push( @stations, [ 277, 109, 20, 'Wasserwerk',         6091287, 0 ] );
push( @stations, [ 28,  100, 20, 'Westpfalz-Klinikum', 1882,    7312000 ] );
push( @stations, [ 347, 233, 20, 'Wildpark',           1835,    7312000 ] );
push( @stations, [ 199, 98,  20, 'Wilhelmsplatz',      6091314, 0 ] );
push( @stations, [ 73,  107, 20, 'Ziegelstr.',         6091275, 0 ] );
push( @stations,
    [ 320, 15, 20, 'Zoar-Heim (Bürgerhospital)', 1876, 7312000 ] );

@stations = ();

push( @stations, [ 188, 233, 20, '23er Kaserne',   6091001, 0 ] );
push( @stations, [ 338, 242, 20, 'Abzw. Autobahn', 6006230, 0 ] );
push( @stations, [ 186, 157, 20, 'Alex-Müller-Heim (AWO)', 1842, 7312000 ] );
push( @stations, [ 169, 161, 20, 'Altenheim',           6091009, 0 ] );
push( @stations, [ 58,  219, 20, 'Altenwoogstr.',       6091010, 0 ] );
push( @stations, [ 34,  182, 20, 'Alter Friedhof',      6091011, 0 ] );
push( @stations, [ 296, 310, 20, 'Beilsteinschule',     1726,    7312000 ] );
push( @stations, [ 78,  191, 20, 'Christuskirche',      1992,    7312000 ] );
push( @stations, [ 43,  279, 20, 'DEKRA-Akademie',      1709,    7312000 ] );
push( @stations, [ 261, 243, 20, 'Daennerkaserne',      6006227, 0 ] );
push( @stations, [ 94,  220, 20, 'Daniel-Häberle-Str.', 6091051, 0 ] );
push( @stations, [ 163, 106, 20, 'Donnersbergstr.',     6091058, 0 ] );
push( @stations, [ 12,  311, 20, 'Erbsenberg',          6091274, 0 ] )
    ;    #411685 // 5476827
push( @stations, [ 45, 319, 20, 'Erbsenbergsportanlage', 2094, 7312000 ] );
push( @stations, [ 360, 32, 20, 'Eselsfürth', 6091084, 0 ] )
    ;    #414630 // 5479273
push( @stations, [ 274, 25, 20, 'Eselsfürth Brücke',        6091085, 0 ] );
push( @stations, [ 396, 12, 20, 'Eselsfürth Wendeschleife', 6091086, 0 ] );
push( @stations, [ 210, 66, 20, 'Europaallee',              6091246, 0 ] );
push( @stations,
    [ 68, 189, 20, 'Evang. Kinder- u. Jugendheim', 1877, 7312000 ] );
push( @stations, [ 153, 71, 20, 'Flickerstal', 6091093, 0 ] );
push( @stations,
    [ 332, 331, 20, 'Forstamt (Stiftwalder Forsth.)', 1910, 7312000 ] );
push( @stations, [ 127, 225, 20, 'Friedhof',              6006225, 0 ] );
push( @stations, [ 152, 187, 20, 'Friedhof Eingang West', 6091304, 0 ] );
push( @stations, [ 251, 330, 20, 'Gaststätte Quack',      6091340, 0 ] );
push( @stations, [ 341, 222, 20, 'Generaldepot',          6006228, 0 ] );
push( @stations,
    [ 143, 150, 20, 'Geschwister-Scholl-Schule', 1763, 7312000 ] );
push( @stations, [ 132, 160, 20, 'Geschwister-Scholl-Schule', 6091170, 0 ] );
push( @stations, [ 145, 194, 20, 'Grünflächenamt',     1912,    7312000 ] );
push( @stations, [ 112, 128, 20, 'Gärtnereistr.',      6091121, 0 ] );
push( @stations, [ 196, 201, 20, 'Hauptfriedhof',      1985,    7312000 ] );
push( @stations, [ 123, 72,  20, 'Hertelsbrunnenring', 6091134, 0 ] );
push( @stations, [ 67,  90,  20, 'Hölzengraben',       6091152, 0 ] );
push( @stations, [ 136, 116, 20, 'Im Grübentälchen',   6091155, 0 ] );
push( @stations,
    [ 224, 83, 20, 'Industrie- u. Handelsk. (IHK)', 1839, 7312000 ] );
push( @stations, [ 74,  285, 20, 'Jugendverkehrsschule', 1771,    7312000 ] );
push( @stations, [ 242, 95,  20, 'Kopenhagener Str.',    6091279, 0 ] );
push( @stations, [ 223, 83, 20, 'Krankengymnastikschule', 1872, 7312000 ] );
push( @stations, [ 210, 312, 20, 'Licht-Luft',           6091339, 0 ] );
push( @stations, [ 29,  234, 20, 'Lutherkirche',         2008,    7312000 ] );
push( @stations, [ 215, 89,  20, 'Luxemburger Str.',     6091270, 0 ] );
push( @stations, [ 99,  107, 20, 'Mainzer Str.',         6091205, 0 ] );
push( @stations, [ 21,  249, 20, 'Maria-Schutz Kirche',  2009,    7312000 ] );
push( @stations, [ 78,  153, 20, 'Mennonitenstr.',       6091214, 0 ] );
push( @stations, [ 24,  233, 20, 'Messeplatz',           6091217, 0 ] );
push( @stations, [ 183, 258, 20, 'Methodistenkirche',    2011,    7312000 ] );
push( @stations, [ 200, 103, 20, 'Oskar-Schlemmer-Ring', 6091271, 0 ] );
push( @stations, [ 218, 58,  20, 'P+R PRE-Park',         6091263, 0 ] );
push( @stations, [ 190, 57,  20, 'PRE-Park',             6091235, 0 ] );
push( @stations, [ 412, 255, 20, 'Panzerkaserne',        6006256, 0 ] );
push( @stations, [ 297, 242, 20, 'Real-Multi-Markt',     6006254, 0 ] );
push( @stations, [ 228, 92, 20, 'SWA Software Akademie', 1716, 7312000 ] );
push( @stations, [ 260, 307, 20, 'Schule am Beilstein', 6091331, 0 ] );
push( @stations,
    [ 168, 304, 20, 'Sportanlage Entersweilerstr.', 1960, 7312000 ] );
push( @stations, [ 78, 301, 20, 'Sportanlage Kniebrech', 1955, 7312000 ] );
push( @stations,
    [ 33, 262, 20, 'St. Hedwigs-Heim (Caritas)', 1875, 7312000 ] );
push( @stations, [ 94,  166, 20, 'St. Norbert Kirche', 2021,    7312000 ] );
push( @stations, [ 157, 265, 20, 'Stiftswaldschule',   1781,    7312000 ] );
push( @stations, [ 186, 254, 20, 'Stiftswaldstr.',     6091292, 0 ] );
push( @stations,
    [ 74, 115, 20, 'Technisches Hilfswerk (THW)', 1840, 7312000 ] );
push( @stations,
    [ 218, 319, 20, 'Tennisplatz Entersweilerstr.', 1972, 7312000 ] );
push( @stations, [ 197, 63,  20, 'UCI Kinowelt',        6091345, 0 ] );
push( @stations, [ 185, 68,  20, 'UCI-Kinowelt',        1786,    7312000 ] );
push( @stations, [ 119, 269, 20, 'Volkspark',           1828,    7312000 ] );
push( @stations, [ 181, 139, 20, 'Walter-Gropius-Str.', 6091272, 0 ] );
push( @stations, [ 154, 289, 20, 'Warmfreibad',         1834,    7312000 ] );
push( @stations, [ 165, 288, 20, 'Warmfreibad',         6091327, 0 ] );
push( @stations, [ 52,  271, 20, 'Wasserwerk',          6091287, 0 ] );
push( @stations, [ 259, 259, 20, 'Zentraler Betriebshof', 6091342, 0 ] );
push( @stations,
    [ 95, 177, 20, 'Zoar-Heim (Bürgerhospital)', 1876, 7312000 ] );
push( @stations, [ 68,  113, 20, 'Zschockestr.', 6091335, 0 ] );
push( @stations, [ 265, 111, 20, 'monte mare',   1832,    7312000 ] );
push( @stations, [ 277, 109, 20, 'monte mare',   6091276, 0 ] );

@stations = ();
push( @stations, [ 431, 325, 20, 'Alte Brücke', 6091008, 0 ] )
    ;    #409277 // 5477743
push( @stations, [ 356, 164, 20, 'Am Alberichsberg',  6091013, 0 ] );
push( @stations, [ 396, 196, 20, 'Am Hammerweiher',   6091014, 0 ] );
push( @stations, [ 243, 81,  20, 'Am Hang',           6091015, 0 ] );
push( @stations, [ 272, 65,  20, 'Am Hüttenbrunnen',  6091017, 0 ] );
push( @stations, [ 413, 213, 20, 'Blechhammerweg',    6091039, 0 ] );
push( @stations, [ 386, 316, 20, 'Bonhoeffer Kirche', 1989,    7312000 ] );
push( @stations, [ 375, 252, 20, 'Breslauer Str.',    6091040, 0 ] );
push( @stations, [ 114, 32, 20, 'Dressurplatz Erfenbach', 1951, 7312000 ] );
push( @stations, [ 432, 178, 20, 'Engelshof',            6091068, 0 ] );
push( @stations, [ 160, 8,   20, 'Erfenbach Sportplatz', 6091078, 0 ] )
    ;    #406948 // 5480451
push( @stations, [ 222, 99,  20, 'Erfenbacher Weg',     6091080, 0 ] );
push( @stations, [ 310, 152, 20, 'Erzhütten',           6091082, 0 ] );
push( @stations, [ 290, 147, 20, 'Erzhütten Schule',    6091083, 0 ] );
push( @stations, [ 286, 149, 20, 'Erzhüttenschule',     1760,    7312000 ] );
push( @stations, [ 340, 290, 20, 'Fischerrückschule',   1761,    7312000 ] );
push( @stations, [ 255, 138, 20, 'Friedhof Erzhütten',  1980,    7312000 ] );
push( @stations, [ 2,   43,  20, 'Friedhof Siegelbach', 1984,    7312000 ] );
push( @stations, [ 469, 279, 20, 'Gartenschau',         1826,    7312000 ] );
push( @stations, [ 329, 143, 20, 'Gustav-Adolf Kirche', 1995,    7312000 ] );
push( @stations, [ 441, 217, 20, 'Kaiserberg',          6091162, 0 ] );
push( @stations, [ 381, 169, 20, 'Kaisermühle',         6091164, 0 ] );
push( @stations, [ 335, 24,  20, 'Kreuzhof',            6091189, 0 ] );
push( @stations, [ 369, 278, 20, 'Königsberger Str.',   6091185, 0 ] );
push( @stations, [ 333, 311, 20, 'Marienburger Str.',   6091209, 0 ] );
push( @stations, [ 441, 248, 20, 'Neumühle',            6091226, 0 ] );
push( @stations, [ 411, 301, 20, 'Pfeifertälchen',      6091250, 0 ] );
push( @stations, [ 395, 319, 20, 'Schillerschule',      6091179, 0 ] );
push( @stations, [ 401, 326, 20, 'Schillerschule',      1779,    7312000 ] );
push( @stations, [ 157, 16,  20, 'Sportanlage Erfenbach',  1956, 7312000 ] );
push( @stations, [ 313, 135, 20, 'Sportanlage Erzhütten',  1958, 7312000 ] );
push( @stations, [ 326, 299, 20, 'Sportplatz Fischerrück', 1971, 7312000 ] );
push( @stations, [ 277, 142, 20, 'St. Michael Kirche',     2020, 7312000 ] );
push( @stations, [ 313, 38,  20, 'Steig',           6091289, 0 ] );
push( @stations, [ 324, 4,   20, 'Storchenacker',   6091294, 0 ] );
push( @stations, [ 298, 331, 20, 'Vogelwoogstr.',   6091324, 0 ] );
push( @stations, [ 442, 296, 20, 'Westbahnhof',     6008021, 0 ] );
push( @stations, [ 249, 118, 20, 'Wiesenthalerhof', 6091332, 0 ] );

@stations = ();

push( @stations,
    [ 186, 276, 20, 'Albert-Schweitzer-Gymnasium', 1723, 7312000 ] );
push( @stations, [ 263, 334, 20, 'Albrechtstr.',     6006214, 0 ] );
push( @stations, [ 184, 204, 20, 'Alex-Müller-Str.', 6091006, 0 ] );
push( @stations, [ 8,   305, 20, 'Alte Brücke',      6091008, 0 ] );
push( @stations, [ 217, 276, 20, 'Alte Stadtmauer',  6091361, 0 ] );
push( @stations, [ 446, 257, 20, 'Altenheim',        6091009, 0 ] );
push( @stations, [ 334, 315, 20, 'Altenwoogstr.',    6091010, 0 ] );
push( @stations, [ 310, 278, 20, 'Alter Friedhof',   6091011, 0 ] );
push( @stations,
    [ 219, 298, 20, 'Altstadttheater E.-Stein-Haus', 1892, 7312000 ] );
push( @stations, [ 50,  145, 20, 'An der Galappmühle', 6091018, 0 ] );
push( @stations, [ 122, 321, 20, 'Apostelkirche',      1987,    7312000 ] );
push( @stations, [ 130, 324, 20, 'Apostelkirche',      6091019, 0 ] );
push( @stations,
    [ 240, 283, 20, 'Atlantische Akademie R.-P.', 1705, 7312000 ] );
push( @stations, [ 228, 327, 20, 'Behördenhaus',          1904, 7312000 ] );
push( @stations, [ 164, 324, 20, 'Benedict-Sprachschule', 1707, 7312000 ] );
push( @stations, [ 179, 274, 20, 'Benzinoring', 6091358, 0 ] );
push( @stations, [ 66, 215, 20, 'Berufsbildende Schule I', 1728, 7312000 ] );
push( @stations,
    [ 198, 272, 20, 'Berufsbildende Schule II', 1758, 7312000 ] );
push( @stations, [ 211, 325, 20, 'BfA',                 1905,    7312000 ] );
push( @stations, [ 216, 330, 20, 'Bismarckstr.',        6009050, 0 ] );
push( @stations, [ 156, 303, 20, 'Burgstr.',            6091149, 0 ] );
push( @stations, [ 102, 178, 20, 'Caesarpark',          6091048, 0 ] );
push( @stations, [ 182, 301, 20, 'Casimirsaal',         1896,    7312000 ] );
push( @stations, [ 354, 287, 20, 'Christuskirche',      1992,    7312000 ] );
push( @stations, [ 370, 316, 20, 'Daniel-Häberle-Str.', 6091051, 0 ] );
push( @stations,
    [ 176, 280, 20, 'Deutsch-amerikan. Bürgerbüro', 1906, 7312000 ] );
push( @stations, [ 440, 202, 20, 'Donnersbergstr.', 6091058, 0 ] );
push( @stations,
    [ 212, 325, 20, 'Dt. Angestellten-Akad. (DAA)', 1710, 7312000 ] );
push( @stations, [ 9,   159, 20, 'Engelshof',         6091068, 0 ] );
push( @stations, [ 264, 202, 20, 'Eugen-Hertel-Str.', 6091088, 0 ] );
push( @stations,
    [ 345, 285, 20, 'Evang. Kinder- u. Jugendheim', 1877, 7312000 ] );
push( @stations, [ 145, 219, 20, 'Fachhochschule', 6091090, 0 ] );
push( @stations, [ 138, 236, 20, 'Fachhochschule I (FH)',  1720, 7312000 ] );
push( @stations, [ 101, 283, 20, 'Fachhochschule II (FH)', 1721, 7312000 ] );
push( @stations, [ 168, 316, 20, 'Fackelbrunnen',      6091169, 0 ] );
push( @stations, [ 159, 329, 20, 'Fackelpassage',      6091302, 0 ] );
push( @stations, [ 150, 333, 20, 'Fackelwoogstr.',     6091091, 0 ] );
push( @stations, [ 122, 300, 20, 'Fillmore Musichall', 1784,    7312000 ] );
push( @stations, [ 430, 167, 20, 'Flickerstal',        6091093, 0 ] );
push( @stations, [ 152, 242, 20, 'Fliegerstr.',        6091094, 0 ] );
push( @stations,
    [ 144, 332, 20, 'Franziskanerinnen Kapelle', 1993, 7312000 ] );
push( @stations, [ 135, 112, 20, 'Freibad Waschmühle', 1831,    7312000 ] );
push( @stations, [ 403, 321, 20, 'Friedhof',           6006225, 0 ] );
push( @stations, [ 428, 283, 20, 'Friedhof Eingang West', 6091304, 0 ] );
push( @stations, [ 194, 305, 20, 'Fruchthalle',        1897,    7312000 ] );
push( @stations, [ 91,  126, 20, 'Galappmühler Str.',  6091097, 0 ] );
push( @stations, [ 126, 207, 20, 'Galerie Wack',       1887,    7312000 ] );
push( @stations, [ 256, 246, 20, 'Galerie Zeitstrahl', 1888,    7312000 ] );
push( @stations, [ 46,  258, 20, 'Gartenschau',        1826,    7312000 ] );
push( @stations,
    [ 420, 245, 20, 'Geschwister-Scholl-Schule', 1763, 7312000 ] );
push( @stations, [ 408, 256, 20, 'Geschwister-Scholl-Schule', 6091170, 0 ] );
push( @stations, [ 422, 290, 20, 'Grünflächenamt', 1912, 7312000 ] );
push( @stations,
    [ 208, 281, 20, 'Gymnasium am Rittersberg', 1766, 7312000 ] );
push( @stations,
    [ 162, 297, 20, 'Gymnasium an der Burgstr.', 1767, 7312000 ] );
push( @stations, [ 388, 223, 20, 'Gärtnereistr.', 6091121, 0 ] );
push( @stations, [ 223, 258, 20, 'Hackstr.',      6091123, 0 ] );
push( @stations,
    [ 183, 327, 20, 'Handwerkskammer der Pfalz', 1838, 7312000 ] );
push( @stations, [ 225, 220, 20, 'Haspelstr.',          6091128, 0 ] );
push( @stations, [ 472, 297, 20, 'Hauptfriedhof',       1985,    7312000 ] );
push( @stations, [ 150, 250, 20, 'Hauptzollamt',        1913,    7312000 ] );
push( @stations, [ 400, 167, 20, 'Hertelsbrunnenring',  6091134, 0 ] );
push( @stations, [ 343, 185, 20, 'Hölzengraben',        6091152, 0 ] );
push( @stations, [ 413, 211, 20, 'Im Grübentälchen',    6091155, 0 ] );
push( @stations, [ 146, 275, 20, 'Japanischer Garten',  1827,    7312000 ] );
push( @stations, [ 154, 287, 20, 'Jesu-Christi Kirche', 1997,    7312000 ] );
push( @stations,
    [ 233, 283, 20, 'Jugend- u. Programmzentr. (JUZ)', 1898, 7312000 ] );
push( @stations,
    [ 175, 280, 20, 'KL Umweltberatung (KLUB)', 1914, 7312000 ] );
push( @stations, [ 18,  197, 20, 'Kaiserberg',     6091162, 0 ] );
push( @stations, [ 103, 199, 20, 'Kaiserbergring', 6091163, 0 ] );
push( @stations, [ 251, 274, 20, 'Kaiserbrunnen',  1944,    7312000 ] );
push( @stations, [ 64,  276, 20, 'Kammgarn',       6091166, 0 ] );
push( @stations, [ 79,  332, 20, 'Kammgarnstr.',   6091167, 0 ] );
push( @stations,
    [ 228, 327, 20, 'Katasteramt (Behördenhaus)', 1915, 7312000 ] );
push( @stations, [ 201, 328, 20, 'Kino Central',            1785, 7312000 ] );
push( @stations, [ 125, 3,   20, 'Kirche, ev., Morlautern', 2006, 7312000 ] );
push( @stations,
    [ 180, 294, 20, 'Kommunales Studieninst. (KSI)', 1712, 7312000 ] );
push( @stations, [ 73,  316, 20, 'Kottenschule',       1772,    7312000 ] );
push( @stations, [ 163, 284, 20, 'Kreisverwaltung',    6091357, 0 ] );
push( @stations, [ 172, 277, 20, 'Kreisverwaltung',    1917,    7312000 ] );
push( @stations, [ 211, 236, 20, 'Kreiswehrersatzamt', 1918,    7312000 ] );
push( @stations, [ 226, 315, 20, 'Kulturamt',          6006213, 0 ] );
push( @stations,
    [ 228, 327, 20, 'Kulturamt (Behördenhaus)', 1919, 7312000 ] );
push( @stations, [ 78,  281, 20, 'Kulturzentrum Kammgarn',  1900, 7312000 ] );
push( @stations, [ 269, 331, 20, 'Landeszentralbank (LZB)', 1923, 7312000 ] );
push( @stations, [ 161, 251, 20, 'Landwirtschaftsschule',   1774, 7312000 ] );
push( @stations, [ 250, 270, 20, 'Ludwigstr.',           6091362, 0 ] );
push( @stations, [ 271, 300, 20, 'Luitpoldschule',       1775,    7312000 ] );
push( @stations, [ 306, 331, 20, 'Lutherkirche',         2008,    7312000 ] );
push( @stations, [ 376, 203, 20, 'Mainzer Str.',         6091205, 0 ] );
push( @stations, [ 253, 273, 20, 'Mainzer Tor',          6091206, 0 ] );
push( @stations, [ 276, 296, 20, 'Mannheimer Str.',      6091207, 0 ] );
push( @stations, [ 194, 332, 20, 'Marktstr.',            6091210, 0 ] );
push( @stations, [ 194, 267, 20, 'Martin-Luther-Str.',   6091211, 0 ] );
push( @stations, [ 277, 259, 20, 'Max und Moritz',       6091216, 0 ] );
push( @stations, [ 167, 294, 20, 'Maxstr.',              6091212, 0 ] );
push( @stations, [ 228, 306, 20, 'Medienzentrum (MZKL)', 1713,    7312000 ] );
push( @stations,
    [ 186, 252, 20, 'Meisterschule für Handwerker', 1714, 7312000 ] );
push( @stations, [ 355, 248, 20, 'Mennonitenstr.',        6091214, 0 ] );
push( @stations, [ 300, 329, 20, 'Messeplatz',            6091217, 0 ] );
push( @stations, [ 146, 26,  20, 'Morlautern Kieferberg', 6091329, 0 ] );
push( @stations, [ 154, 18,  20, 'Morlautern Rathaus',    6091221, 0 ] );
push( @stations, [ 209, 299, 20, 'Musikschule', 1715,    7312000 ] );
push( @stations, [ 120, 290, 20, 'Mühlstr.',    6091223, 0 ] );
push( @stations, [ 17,  228, 20, 'Neumühle',    6091226, 0 ] );
push( @stations,
    [ 157, 18, 20, 'Ortsverwaltung Morlautern', 1928, 7312000 ] );
push( @stations, [ 99,  329, 20, 'Pfaffpl./Pariser Str.',  6091282, 0 ] );
push( @stations, [ 102, 333, 20, 'Pfaffplatz',             6006221, 0 ] );
push( @stations, [ 99,  329, 20, 'Pfaffplatz/Pariserstr.', 6006226, 0 ] );
push( @stations, [ 233, 330, 20, 'Pfalzbibliothek',   1883,    7312000 ] );
push( @stations, [ 182, 259, 20, 'Pfalzgalerie',      1889,    7312000 ] );
push( @stations, [ 190, 287, 20, 'Pfalztheater',      1893,    7312000 ] );
push( @stations, [ 238, 303, 20, 'Polizei (Gaustr.)', 1941,    7312000 ] );
push( @stations, [ 183, 305, 20, 'Rathaus',           6006220, 0 ] );
push( @stations,
    [ 178, 291, 20, 'Rathaus / Stadtverwaltung', 1931, 7312000 ] );
push( @stations, [ 188, 231, 20, 'SWR',               6091023, 0 ] );
push( @stations, [ 191, 308, 20, 'Schillerplatz',     6091178, 0 ] );
push( @stations, [ 96,  222, 20, 'Schulzentrum Nord', 6091267, 0 ] );
push( @stations, [ 66,  215, 20, 'Schulzentrum Nord', 1871,    7312000 ] );
push( @stations, [ 150, 311, 20, 'Seniorenheim KL-Mitte', 1848, 7312000 ] );
push( @stations, [ 68,  182, 20, 'Sonnenberg', 6091268, 0 ] );
push( @stations, [ 197, 317, 20, 'Spinnrädl',  1947,    7312000 ] );
push( @stations, [ 145, 59,  20, 'Sportanlage Morlautern',  1962, 7312000 ] );
push( @stations, [ 169, 25,  20, 'St. Bartholomäus Kirche', 2014, 7312000 ] );
push( @stations, [ 215, 304, 20, 'St. Martin Kirche',       1950, 7312000 ] );
push( @stations, [ 371, 262, 20, 'St. Norbert Kirche',      2021, 7312000 ] );
push( @stations, [ 138, 330, 20, 'St.-Franziskus-Schule',   1780, 7312000 ] );
push( @stations,
    [ 178, 291, 20, 'Stadtarchiv (im Rathaus)', 1932, 7312000 ] );
push( @stations, [ 226, 301, 20, 'Stadtbibliothek', 1884, 7312000 ] );
push( @stations, [ 204, 322, 20, 'Stiftskirche',    1948, 7312000 ] );
push( @stations,
    [ 207, 291, 20, 'Stiftskirche, Kleine Kirche', 2018, 7312000 ] );
push( @stations, [ 222, 314, 20, 'Stiftsplatz', 6091291, 0 ] );
push( @stations, [ 184, 227, 20, 'Südwestrundfunk (SWR)', 1901, 7312000 ] );
push( @stations,
    [ 104, 291, 20, 'Technische Akad. Südw. (TAS)', 1717, 7312000 ] );
push( @stations,
    [ 155, 305, 20, 'Technische Werke KL (TWK)', 1933, 7312000 ] );
push( @stations,
    [ 351, 211, 20, 'Technisches Hilfswerk (THW)', 1840, 7312000 ] );
push( @stations, [ 92, 149, 20, 'Tennisplatz Galappmühle', 1973, 7312000 ] );
push( @stations, [ 221, 191, 20, 'Theodor-Heuss-Schule', 6091266, 0 ] );
push( @stations, [ 219, 200, 20, 'Theodor-Heuss-Schule', 1783,    7312000 ] );
push( @stations, [ 241, 284, 20, 'Theodor-Zink-Museum',  1890,    7312000 ] );
push( @stations, [ 228, 306, 20, 'Volkshochschule (VHS)', 1719, 7312000 ] );
push( @stations, [ 238, 278, 20, 'Wadgasserhof',          1891, 7312000 ] );
push( @stations, [ 121, 116, 20, 'Waschmühle',    6091328, 0 ] );
push( @stations, [ 19,  275, 20, 'Westbahnhof',   6008021, 0 ] );
push( @stations, [ 254, 248, 20, 'Zeppelinplatz', 6091338, 0 ] );
push( @stations,
    [ 371, 273, 20, 'Zoar-Heim (Bürgerhospital)', 1876, 7312000 ] );
push( @stations, [ 344, 209, 20, 'Zschockestr.', 6091335, 0 ] );

my $dbh = Mofa::Model::connect_db();
my $i   = 1;
foreach my $station (@stations) {
    my ( $x, $y ) = coords( $station->[0], $station->[1] );
    my $pt = Mofa::MeetingPt->new(
        {   utm_x       => $x,
            utm_y       => $y,
            utm_e       => 32,
            utm_n       => 'U',
            name        => "Kaiserslautern Bus " . $station->[3],
            description => "Kaiserslautern Bus " . $station->[3],
            street      => $station->[3],
            nr          => '',
            zip         => '67',
            city        => 'Kaiserslautern',
            state       => 'DE',
            region      => 'Rheinland-Pfalz',
            district    => 'Kaiserslautern'
        }
    );
    $pt->add($dbh);
    print $station->[3], "($x; $y) hinzugefügt ($i)\n";
    $i++;
}
