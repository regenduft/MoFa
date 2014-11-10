package Mofa::View;

=head1 Mofa::View

Stellt Funktionen zur Ausgabe von WML-Seiten zur Verf�gung

=cut
use strict;
use warnings;

use CGI qw(-compile :standard card Do go setvar postfield anchor small prev timer);
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;
use CGI::WML;
use URI::Escape;
use POSIX qw(strftime);

use Exporter;
our (@ISA)    = qw(Exporter);
our (@EXPORT) = qw(display_err display_msg sendwml $session myparam);

our ($wml)     = CGI::WML->new();
our ($session) = CGI::Session->new() or die CGI::Session->errstr;

=pod

=head4 C<$ get_link(@)>

I<Parameter:> Datei, auf die verlinkt werden soll (C<string>),
Liste von Referenzen auf 2-Elementige Listen
mit Paaren der Form (key, value) f�r zu �bermittelnde
Daten

I<R�ckgabewert:> String mit Get-Link zu der angebene Seite (mit Session-Id)

=cut
sub get_link {
    my $link = shift();
    return go(
        { -href => $link, -method => 'get' },
        map { postfield( { -name => $_->[0], -value => $_->[1] } ); }
            ( [ $session->name(), $session->id() ], @_ )
    );
}

=pod

=head4 C<$ post_link(@)>

I<Parameter:> Datei, auf die verlinkt werden soll (C<string>),
Liste von Referenzen auf 2-Elementige Listen
mit Paaren der Form (key, value) f�r zu �bermittelnde
Daten

I<R�ckgabewert:> String mit Post-Link zu der angebene Seite (mit Session-Id)

=cut
sub post_link {
    return go(
        {   -href => shift() . '?' . $session->name() . '=' . $session->id(),
            -method => 'post'
        },
        map { postfield( { -name => $_->[0], -value => $_->[1] } ); }
            ( [ $session->name(), $session->id() ], @_ )
    );
}

sub map_link {
    my ($ux, $uy) = @_;
    $session->param('map_back_link', url(-query=>1, -relative=>1));
    return a(  
        { -href => "display_map.pl?".$session->name()."=".$session->id()."&utm_x=$ux&utm_y=$uy" },
        '(->Karte)'
    );
}

=pod

=head4 C<$ back_link()>

I<R�ckgabewert:> C<string> mit zur�ck-Link

=cut
sub back_link {
    return p( small( anchor( 'Zurueck', prev() ) ) );
}

=pod

=head4 C<$ logout_link()>

I<R�ckgabewert:> falls angemeldet: C<string> mit Link um sich abzumelden;
                  sonst: leerer C<string>                  

=cut
sub logout_link {
    if ( defined( $session->param('login') )
        and $session->param('login') ne '' )
    {
        return p(
            small( a( { -href => 'index.pl?logout=1' }, 'Abmelden' ) ) );
    }
    else {
        return ' ';
    }
}

=pod

=head4 C<$ card_login()>

I<R�ckgabewert:> C<string> mit WML-Card: komplettes Login-Formular

=cut
sub card_login {
    return (
        card(
            { -title => 'Login', -id => 'login' },
            Do( { -type => 'accept', label => "Login" },
                post_link(
                    'login.pl',
                    [ 'login',    '$(i_login)' ],
                    [ 'password', '$(i_password)' ]
                )
            ),
            p(  'Login: ',
                input(
                    { -type => 'text', -name => 'i_login', -size => '10' }
                ),
                br(),
                'Passwort: ',
                input(
                    { -type => 'text', -name => 'i_password', -size => '10' }
                ),
                br()
            ),
            p(  anchor(
                    'Einloggen',
                    post_link(
                        'login.pl',
                        [ 'login',    '$(i_login)' ],
                        [ 'password', '$(i_password)' ]
                    )
                )
            ),
            back_link()
        )
    );
}

=pod

=head4 C<$ card_anon_start()>

I<R�ckgabewert:> C<string> mit WML-Card:
     Startseite optimiert f�r nicht angemeldete Benutzer

=cut
sub card_anon_start {
    return card(
        { -title => 'Hitchhiker', -id => 'anon_start' },
        p(  { -align => 'center' },
            small( strong('Hitchhikers mobile Guide') ),
            br(),
            small('Der verlaengerte Daumen fuer per-Anhalter-Reisende')
        ),
        p(  { -align => 'center' },
            small( a( { -href => '#login' }, 'Login' ) )
        ),
        p(  { -align => 'center' },
            a( { -href => '#search' }, 'Zum Suchformular' )
        ),
        p(  { -align => 'center' },
            small(
                a( { -href => '#entry' }, 'Mitfahrgelegenheit eintragen' )
            )
        ),
        p(  { -align => 'center' },
            small( a( { -href => '#infos' }, 'Weitere Informationen' ) )
        ),
        p(  { -align => 'center' },
            small(
                a(  { -href => 'http://anhalter.here.de' },
                    'anhalter.here.de'
                ),
                br(),
                a( { -href => 'http://mfg.4u.gs' }, 'mfg.4u.gs' ),
                " - ",
                a( { -href => 'http://lift.4u.gs' }, 'lift.4u.gs' )
            )
        ),
        Do( { -type => 'accept', label => "Suche" },
            go( { -href => '#search' } )
        )
    );
}

=pod

=head4 C<$ card_search($$$)>

I<Parameter:> Vorgaben f�r Startpunkte (Referenz auf Liste von C<Mofa::Model::Address>-Objekten),
Vorgaben f�r Endpunkte (Referenz auf Liste von C<Mofa::Model::Address>-Objekten),
URL an die Formular gesendet werden soll (C<string>)

I<R�ckgabewert:> C<string> mit WML-Card: Suchformular mit Start, Ziel, Zeit

=cut
sub card_search {
    my ( $starts, $dests, $link ) = @_;
    if ( not defined($link) or $link eq '' ) { $link = 'search.pl'; }
    return card(
        { -title => 'MFG suchen', -id => 'search' },
        p(  'Start: ',
            (   scalar( @{$starts} ) > 0
                ? popup_menu(
                    {   -name   => 'i_start',
                        -values => [ map { $_->id(); } @{$starts} ],
                        -labels => {
                            map {
                                $_->id() => $_->description() . ' ('
                                    . eval { $_->accuracy() } . ')';
                                } @{$starts}
                        }
                    }
                    )
                : input(
                    { -type => 'text', -name => 'i_start', -size => '15' }
                )
            ),
            br(),
            'Ziel: ',
            (   scalar( @{$dests} ) > 0
                ? popup_menu(
                    {   -name   => 'i_dest',
                        -values => [ map { $_->id(); } @{$dests} ],
                        -labels => {
                            map {
                                $_->id() => $_->description() . ' ('
                                    . eval { $_->accuracy() } . ')';
                                } @{$dests}
                        }
                    }
                    )
                : input(
                    { -type => 'text', -name => 'i_dest', -size => '15' }
                )
            ),
            br(),
            'Wann: ',
            popup_menu(
                {   -name   => 'i_time',
                    -values => [ 'Jetzt', 'Morgen', 'Uebermorgen' ]
                }
            ),
            br(),
            small(
                anchor(
                    get_link(
                        $link,
                        [ 'start', '$(i_start)' ],
                        [ 'dest',  '$(i_dest)' ],
                        [ 'time',  '$(i_time)' ]
                    ),
                    'Formular Senden'
                )
            )
        ),
        back_link(),
        logout_link(),
        Do( { -type => 'accept', label => 'Senden' },
            get_link(
                $link,
                [ 'start', '$(i_start)' ],
                [ 'dest',  '$(i_dest)' ],
                [ 'time',  '$(i_time)' ]
            ),
        )
    );
}

=pod

=head4 C<$ card_entry($$)>

I<Parameter:> Vorgaben f�r Startpunkte (Referenz auf Liste von C<Mofa::Model::Address>-Objekten)),
Vorgaben f�r Endpunkte (Referenz auf Liste von C<Mofa::Model::Address>-Objekten),
URL an die Formular gesendet werden soll (C<string>)

I<R�ckgabewert:> C<string> mit WML-Card: Eingabeformular f�r neue MFG

=cut
sub card_entry($$) {
    return card( { -title => 'Hitchhiker', -id => 'entry' },
        p('noch leer'), back_link(), logout_link() );
}

=pod

=head4 C<$card_infos()>

I<R�ckgabewert:> C<string> mit WML-Card: Infos/Impressum 

=cut 
sub card_infos {
    return card(
        { -title => 'Hitchhiker', -id => 'infos' },
        p('Mehr Infos bei jostock@rhrk.uni-kl.de'),
        back_link()
    );
}

=pod

=head4 C<$ card_bookmark()>

I<R�ckgabewert:> C<string> mit WML-Card: Enth�lt Link der
als Bookmark zum automatischem Login gespeichert werden kann.

=cut
sub card_bookmark {
    return card(
        {   -title => 'Hitchhiker fuer ' . $session->param('login'),
            -id    => 'bookmark'
        },
        p(  small(
                'Angemeldet als ', $session->param('login') . '.', br(),
                'Rufst du ein Lesezeichen zu',
                a( { -href => '#search' }, 'dieser' ),
                '  Adresse auf, wirst du automatisch angemeldet. Das Lesezeichen
				wird ungueltig sobald du dich abmeldest!'
            )
        ),
        p(  small(
                a( { -href => '#search' }, 'Mitfahrgelegenheit suchen' ),
                br(),
                a( { -href => '#entry' }, 'Mitfahrgelegenheit eintragen' ),
            )
        ),
        logout_link(),
        Do( { -type => 'accept', label => "Suche" },
            go( { -href => '#search' } )
            )

    );
}

=pod

=head4 C<$ card_personal_menu()>

I<R�ckgabewert:> C<string> mit WML-Card: Startseite nach dem Einloggen.

=cut
sub card_personal_menu {
    return (
        card(
            {   -title => 'Hitchhiker Menu von ' . $session->param('login'),
                -id    => 'menu'
            },
            p(  { -align => 'center' },
                small( strong( $session->param('login') . 's Optionen' ) )
            ),
            p(  { -align => 'center' },
                small(
                    'du kannst eine:',
                    br(),
                    anchor('MFG suchen', get_link('assist.pl',['type','request'])),br(),
                    br(),
                    anchor('MFG anbieten', get_link('assist.pl',['type','offer'])),br(),
                )
            ),
            p(  small(
                    'Lege ein Lesezeichen an, um beim Aufruf automatisch angemeldet
			zu werden. Es verf�llt jedoch beim Abmelden und muss gel�scht und nach dem
			n�chstem Login neu angelegt werden.'
                )
            ),
            p(  { -align => 'center' },
                small( anchor( get_link('logout.pl'), 'Abmelden' ) )
            )
        )
    );
}

=head4 C<login()>

Checks if the submitted parameters match a login-id and password from the
DB, saves the login-id to the session and prints login_splash()
in case of success or login_failure() if no success.

=cut 
sub login {
    if ( defined( param('login') ) and param('login') ne '' ) {
        $session->param( 'login', param('login') );
        return login_splash(@_);
    }
    return login_failure(@_);
}

=head4 C<personal_index()>

Gibt ein WML-Deck mit einigen WML-Cards als Startseite
nach dem einloggen aus. Falls der Benutzer nicht eingeloggt ist
wird stattdessen login_failure() ausegegeben. 

=cut
sub personal_index {
    if (not( defined( $session->param('login') )
            and $session->param('login') ne '' )
        )
    {
        return login_failure(@_);
    }
    sendwml( card_personal_menu(), card_bookmark(),
        card_search( [], [], 'geocode.pl' ) );
}

=head4 C<anon_index()>

Gibt ein WML-Deck mit einigen Cards als allgemeine
Startseite aus. Falls logout=1 �bermittelt wurde, wird
der Benutzer auch noch ausgeloggt.

=cut
sub anon_index {
    if ( defined( param('logout') ) and param('logout') eq '1' ) {
        $session->delete();
    }
    sendwml(
        card_anon_start(), card_login(),
        card_search( [], [], 'geocode.pl' ),
        card_entry( [], [] ),
        card_infos(),
    );
}

=head4 C<register_sms_sent($)>

I<Parameter:> R�ckgabewert des SMS-Servicecenter (C<string>)

Gibt ein WML-Deck aus, das anzeigt, dass die SMS zur
Verifikation der Telefonnummer eines neu registrierten
Benutzers versendet wurde. 

=cut
sub register_sms_sent {
    my ($res) = @_;
    sendwml(
        card(
            { -title => 'sms gesendet', -id => 'sms' },
            p(  small(
                    'SMS wurde versendet. Schliessen Sie den Browser und rufen sie den',
                    'Link in der SMS auf, um ihre Telefonnummer zu bestaetigen!',
                    br(),
                    'Alternativ geben Sie den Code aus der SMS von Hand hier ein:'
                )
            ),
            p(  small('Code:'),
                input(
                    { -type => 'text', -name => 'i_regkey', -size => 10 }
                )
            ),
            p(  small(
                    anchor(
                        'Code abschicken',
                        get_link( 'confirm.pl', [ 'regkey', '$(i_regkey)' ] )
                    )
                )
            ),
            p( small( "Rueckgabewert des SMS-Servicecenters: $res" ) )
        )
    );
}

=head4 C<logout()>

L�scht die Session. Gibt WML-Deck aus mit der Meldung, dass man ausgeloggt wurde
und Auto-Login-Lesezeichen ung�ltig wurden.

=cut
sub logout {
    my $user = $session->param('login');
    $session->delete();
    sendwml(
        card(
            {   -title   => 'Hitchhiker',
                -id      => 'logout',
                -ontimer => 'index.pl'
            },
            timer( { -value => "100" } ),
            p( { -align => 'center' }, "$user abgemeldet" ),
            p(  { -align => 'center' },
                small(
                    'Falls sie Lesezeichen zu ihrem 
			persoenlichem Bereich gespeichert hatten, sind diese nun
			ungueltig geworden. Sie koennen diese Lesezeichen loeschen und
			nach ihrem naechstem Login neu anlegen.'
                )
            ),
            p(  { -align => 'center' },
                small( a( { -href => 'index.pl' }, 'Zur Startseite' ) )
            ),
            Do( { -type => 'Accept', -label => 'Startseite' },
                go( { -href => 'index.pl', -method => 'get' } )
            )
        )
    );
}

=head4 C<confirm_register()>

Gibt WML-Deck mit Meldung, dass Registrierung abgeschlossen ist, aus.
Leitet an search.pl weiter, wo die Suche fortgesetzt werden kann.

=cut
sub confirm_register {
    sendwml(
        card(
            { -title => 'Registrierung abgeschlossen', -id => 'register' },
            p(  small(
                    'Ihre Telefonnumer wurde best�tigt.',
                    'Sie k�nnen den Mobile Hitchhiker nun in vollem Umfang nutzen'
                )
            ),
            p(  small(
                    'Klicken Sie, um ihre Such-Anfrage fortzusetzen!',
                    br(),
                    anchor(
                        Mofa::View::get_link('search.pl'),
                        'Anfrage senden'
                    )
                )
            ),
            p(  small(
                    anchor(
                        Mofa::View::get_link('p_index.pl'),
                        'Zu ihrer persoenlichen Startseite'
                    )
                )
            )
        )
    );

}

=head4 C<display_map($$$$$$)>

I<Parameter:> URL zum Kartenbild (C<string>), 
Parameter f�r dieses Bild (X, Y, Radius, H�he, Breite) als C<int>

Gibt WML-Deck aus, mit dem Bild an der angegebenen URL und Links zum auszoomen, einzoomen
und evtl. zur Navigation.  

=cut
sub display_map {
    my ( $img_link, $x, $y, $rad, $width, $height ) = @_;
    sendwml(
        card(
            { -title => 'Karte', -id => 'map' },
            p(  { -align => 'center' },
                img( { -src => $img_link, -alt => "Karte" } )
            ),
            p(a( {-href=>$session->param('map_back_link')}, 'Karte ausblenden')),
            p(  
                    a(  {   -href =>
                                "display_map.pl?".$session->name()."=".$session->id()."&x=$x&y=$y&width=$width&height=$height&radius="
                                . $rad * 2
                        },
                        'Auszoomen'
                    ),
                    br(),
                    a(  {   -href =>
                                "display_map.pl?".$session->name()."=".$session->id()."&x=$x&y=$y&width=$width&height=$height&radius="
                                . $rad / 2
                        },
                        'Einzoomen'
                    ),
                    br(),
                    a(  {   -href =>
                                "display_map.pl?".$session->name()."=".$session->id()."&x=$x&y=$y&width=$width&height=$height&radius="
                                . $rad * 6
                        },
                        '3x Auszoomen'
                    ),
                    br(),
                    a(  {   -href =>
                                "display_map.pl?".$session->name()."=".$session->id()."&x=$x&y=$y&width=$width&height=$height&radius="
                                . $rad / 6
                        },
                        '3x Einzoomen'
                    )
            ),
            back_link(),
        )
    );

}

sub desc($) {
    my $pt = shift;
    my $name = eval{$pt->name()};
    if (defined($name) and $name ne '') {return $name;}
    elsif (defined($pt->description()) and $pt->description() ne ''){ return $pt->description();}
    else {return $pt->id()}
}

=head4 C<display_accept(@)>

I<Parameter:> Liste von C<Mapped>-Objekten

Gibt WML-Deck mit einer �bersichts-Card und einer WML-Card f�r
jedes Mapped-Objekt an. Bietet Optionen ein Anfrage zu aktzeptieren
oder abzulehen.

=cut
sub display_accept {
    my (@mapped) = @_;
    sendwml_nocache(
        card(
            { -title => 'Mitfahr-Anfragen', -id => 'accept' },
            p( "Hi " . $session->param('login') . "!" ),
            p(  small(
                    "Format der Liste:",
                    br(),
                    "Startzeit ihrer Fahrt: Gesuch Start - Ziel. Umweg fuer Sie:"
                )
            ),
            map {
            my ($sec, $min, $hour) = localtime($_->offer()->startTime());
            my $stime = strftime("%d.%m. %H:%Mh",localtime($_->offer()->startTime()));
            if ($min == 0 and $hour == 0 ) {$stime = strftime("%d.%m.",localtime($_->offer()->startTime()));}
                p(  small(
                        a(  { -href => "#map" . $_->id() },
                            $stime . ': '
                                . desc($_->request()->start())
                                . ' - '
                                . desc($_->request()->destination())
                                . '. '
                                . $_->{detour} . "km/"
                                . $_->addtime()
                                . " min. "
                        )
                    )
                    )
                } @mapped
        ),
        map {
            my ($sec, $min, $hour) = localtime($_->offer()->startTime());
            my $stime = strftime("%d.%m. %H:%Mh",localtime($_->offer()->startTime()));
            if ($min == 0 and $hour == 0 ) {$stime = strftime("%d.%m.",localtime($_->offer()->startTime()));}
            card(
                {   -title => 'Anfrage von ' . $_->request()->requesterId(),
                    -id    => "map" . $_->id()
                },
                p(        small( "Bei der Fahrt " . $_->offerId() . " von " )
                        . br()
                        . desc($_->offer()->start())
                        . small(" nach")
                        . br()
                        . desc($_->offer()->destination())
                        . br() . "("
                        . $stime . ")"
                        . small(" will ")
                        . $_->request()->requesterId()
                        . small(' mitfahren von ')
                        . br()
                        . desc($_->request()->start())
                        . small(' bis ')
                        . br()
                        . desc($_->request()->destination())
                        . small(".")
                        . br()
                        . small("Umweg: ")
                        . $_->detour()
                        . small(" Km / ")
                        . $_->addtime()
                        . small(" Minuten.")
                ),
                p(  anchor(
                        get_link( "accept.pl", [ 'accept', $_->id() ] ),
                        'Akzeptieren'
                    ),
                    br(),
                    anchor(
                        get_link( "accept.pl", [ 'deny', $_->id() ] ),
                        'Ablehnen'
                    ),
                    br(),
                    a( { -href => "#accept" }, 'Alle Anfragen' )
                )
                )
            } @mapped
    );

}


=head4 C<display_search_form()>

Gibt WML-Deck mit einer Card mit dem Suchformular aus.

=cut
sub display_search_form {
    sendwml( card_search(@_) );
}

=head4 C<display_enter_time()>

Gibt ein WML-Deck mit einer Card zur Eingabe der Startzeit
einer Mitfahrgelegenheit aus.

=cut
sub display_enter_time {
    sendwml(
        card(
            {-title=>'Startzeit'},
            p(
                'Wann moechten Sie losfahren: ',br(),
                anchor(
                    'Jetzt sofort',
                    get_link('assist.pl', ['time', 'jetzt'],['type',param('type')])
                ),br(),
                anchor(
                    'Heute irgendwann',
                    get_link('assist.pl', ['time', 'heute'],['type',param('type')])
                ),br(),
                anchor(
                    'Morgen irgendwann',
                    get_link('assist.pl', ['time', 'morgen'],['type',param('type')])
                ),br(),
                '--Heute:--',br(),
                anchor(
                    'Frueh (6-9h)',
                    get_link('assist.pl', ['time', 'frueh'],['type',param('type')])
                ),br(),
                anchor(
                    'Vormittag (9-12h)',
                    get_link('assist.pl', ['time', 'vormittag'],['type',param('type')])
                ),br(),
                anchor(
                    'Mittag (12-15h)',
                    get_link('assist.pl', ['time', 'mittag'],['type',param('type')])
                ),br(),
                anchor(
                    'Nachmittag (15-18h)',
                    get_link('assist.pl', ['time', 'nachmittag'],['type',param('type')])
                ),br(),
                anchor(
                    'Abend (18-21h)',
                    get_link('assist.pl', ['time', 'abend'],['type',param('type')])
                ),br(),
                anchor(
                    'Nacht (21-6h)',
                    get_link('assist.pl', ['time', 'nacht'],['type',param('type')])
                ),br(),
            )
        )
    );
}

=head4 C<card_enter_point($$$@)>

I<Parameter:> Typ des einzugebenden Punktes (start oder destination) (C<string>),
Anzuzeigende Beschreibung des einzugebenden Punktes (C<string>), id der Card (C<string>),
Liste von C<Mofa::Address>-Objekten die zur Auswahl zur Verf�gung stehen. 

I<R�ckgabewert:> C<string> mit einer WML-Card mit einem Formular zur
Eingabe oder Auswahl eines Treffpunktes.

=cut
sub card_enter_point(@) {
    my ($type, $desc, $id, @locations) = @_;
    my %typename = qw(start Startort destination Zielort);
    my %fields = (start=>['time'], destination=>['time', 'start']);
    my @abbr = (       
    'Baden-Wuerttemb. BW',
    'Bayern BY',
    'Berlin BE',
    'Brandenburg BR',
    'Bremen HB',
    'Hamburg HH',
    'Hessen HE',
    'Mecklenb.-Vorpom. MV',
    'Niedersachsen NI',
    'Nordrhein-Westf. NW',
    'Rheinland-Pfalz RP',
    'Saarland SL',
    'Sachsen SN',
    'Sachsen-Anhalt ST',
    'Schleswig-Holst. SH',
    'Thueringen TH',
    );        
    return card(
            {-title=>$typename{$type}, -id=>$id},
            p(
                small(
                    "Klicken Sie den $typename{$type} an oder geben Sie ihn unten ein:",br()),
                    "--$desc--",br(),
                (map {
                    my $name = eval{$_->name();};
                    if (not defined ($name) or $name eq '') {$name = $_->description . ' (' . $_->district. ', '. $_->region .')';}
                    my $dist = eval{$_->distance()};
                    if (defined($dist) and $dist ne ''){$dist = "(ca ".$dist."km)";}
                    small(anchor(
                       $name, $dist,
                        get_link('assist.pl',[$type, $_->id()],['type',param('type')], map {[$_, param($_)]} @{$fields{$type}})
                    ),map_link($_->utm()),br());
                } @locations),
                ($id eq 'near'? small(a({-href=>'#old'}, 'fruehere Start/Zielorte zeigen:'), br()) : ' '),
                input({-name=>"i_$type"}),br(),
                anchor(
                    get_link('assist.pl', [ $type, '$(i_'."$type)" ],['type',param('type')], map {[$_, param($_)]} @{$fields{$type}}),
                    'Adresse suchen'
                ),br(),
                ($id eq 'geo' ? small(
                    'Ist der gesuchte Ort nicht dabei, geben Sie Bundesland oder PLZ an!',
                    br(), 'Abk�rzungen:', br(),
                    map {($_,br())} @abbr,
                ): ' '), br()
            )
    );
}

=head4 C<display_enter_point($$$$)>

I<Parameter:> Typ des einzugebenden Punktes (start, destination) (C<string>),
je 3 Array-Referenzen auf eine Liste von C<Mofa::Model::Address>-Objekten mit:
Punkten in der Umgebung, Punkten die fr�her schonmal gew�hlt wurden, geocodierten
Punkten.  

Gibt eine WML-Seite zur Eingabe oder Auswahl eines Treffpunktes aus.

=cut
sub display_enter_point($$$$) {
    my ($type, $nearloc, $oldloc, $geoloc) = @_;
    my @nearloc = @{$nearloc};
    my @oldloc = @{$oldloc};
    my @geoloc = @{$geoloc};
    
    sendwml(
        (scalar(@nearloc)>0 ? card_enter_point($type, 'in der Naehe:', 'near', @nearloc) : ' '),
        (scalar(@oldloc)>0 ? card_enter_point($type, 'fruehere Orte:', 'old', @oldloc) : ' '), 
        ((scalar(@geoloc)>0 or scalar(@nearloc) + scalar(@oldloc) == 0) ? card_enter_point($type, 'Meinten Sie:', 'geo', @geoloc) : ' ')
    );
}

=head4 C<display_search_result()>

Gibt WML-Deck mit der Aufforderung sich zu registrieren aus.

=cut
sub display_search_result(@) {
    my @mapped = @_;    #parameter = list of mapped
    sendwml_nocache(
        card(
            { -title => 'Suchergebnis', -id => 'search_result' },
            p(  small(
                    'Registrieren sie sich kostenlos um ',
                    'die Anfrage an die Fahrer zu senden.'
                )
            ),
            p(  { -align => 'right' },
                small('Hdynr'),
                input(
                    {   -type   => 'text',
                        -name   => 'i_phone',
                        -size   => 9,
                        -format => '*N'
                    }
                ),
                br(),
                small('Login '),
                input( { -type => 'text', -name => 'i_login', -size => 5 } ),
                br(),
                small('Passwort '),
                input(
                    {   -type   => 'text',
                        -name   => 'i_password',
                        -size   => 5,
                        -format => '*N'
                    }
                )
            ),
            p(  { -align => 'center' },
                small(
                    anchor(
                        'Registrieren u. Anfrage absenden',
                        get_link(
                            'register.pl',
                            [ 'phone',    '$(i_phone)' ],
                            [ 'login',    '$(i_login)' ],
                            [ 'password', '$(i_password)' ]
                        )
                    )
                )
            ),
            p(  small(
                    'Sie erhalten eine WAP-Push-SMS sobald Sie jemand mitnehmen w�rde.',
                    br(),
                    'Nach der Registrierung erhalten Sie sofort einen Link per SMS, ',
                    'den sie aufrufen m�ssen um einmalig die Telefonnummer zu bestaetigen.',
                    'Danach benachrichtigen wir die Anbieter der MFGs �ber ihre Anfrage.',
                    br(),
                    'In Zukunft melden sie sich einfach mit den oben angegebenen Logindaten an.'
                )
            ),
            map {
                my ( $sx, $sy ) = $_->offer()->start()->utm();
                my ( $dx, $dy ) = $_->offer()->destination()->utm();
                p(  small(
                        'Start: ',
                        $_->offer()->start()->name(),
                        a(  { -href => "display_map.pl?utm_x=$sx&utm_y=$sy" },
                            'Karte'
                        ),
                        br(),
                        'Ziel: ',
                        $_->offer()->destination()->name(),
                        a(  { -href => "display_map.pl?utm_x=$dx&utm_y=$dy" },
                            'Karte'
                        ),
                        br(),
                        'Umweg fuer Autofahrer: ',
                        $_->detour() . 'km/' . $_->addtime() . 'min',
                        br()
                    )
                );
                } @mapped
        )
    );
}

=head4 C<display_err(@)>

I<Parameter>: Fehlermeldungen (C<(string,..)>).

Gibt WML-Deck mit Titel Fehler und jedem �bergebenem String in je einer Zeile aus.
Bittet Browser, die Seite immmer neu zu laden und nicht im Cache abzulegen.

=cut
sub display_err {
    sendwml_nocache( card( { -title => 'Fehler', -id => 'err' }, _msg(@_) ) );
}

=head4 C<display_msg($@)>

I<Parameter>: �berschrift (C<string>), Nachrichten (C<(string,..)>).

Gibt WML-Deck mit dem Titel und jeder Nachricht in einer eigenen Zeile aus.
Deck wird nicht im Cache zwischengespeichert. 

=cut
sub display_msg {
    sendwml_nocache( card( { -title => shift(), -id => 'msg' }, _msg(@_) ) );
}

sub _msg {
    return p( small( join( br(), @_ ), ) ), back_link(),
        p(
        (   (   defined( $session->param('login') )
                    and $session->param('login') ne ''
            )
            ? anchor( get_link('p_index.pl'), 'Pers�nliche Startseite' )
                . br()
            : ' '
        ),
        anchor( get_link('index.pl'), 'Hitchhiker Startseite' ),
        br()
        ),
        Do( { -type => "prev", -label => "Zurueck" }, prev() )

}

=head4 C<login_splash()>

Gibt WML-Deck aus mit einer Meldung �ber erfolgreichen Login, und leitet sofort
an p_index.pl weiter. Dient dazu, Login und Passwort aus der
URL zu entfernen, damit der Benutzer, falls er Lesezeichen speichert, 
nicht sein Passwort im Klartext im Lesezeichen mitspeichert.

=cut
sub login_splash {
    my $weiter = 'p_index.pl?' . $session->name() . '=' . $session->id();
    sendwml_nocache(
        card(
            { -title => "angemeldet", -ontimer => $weiter },
            timer( { -value => "2" } ),
            Do( { -type => "prev", -label => "Zurueck" }, prev() ),
            Do( { -type => "accept" }, go( { -href => $weiter } ) ),
            p(  { -align => "center" },
                small( "Sie haben sich erfolgreich angemeldet." )
            ),
            p(  { -align => "center" },
                small( a( { -href => $weiter }, "Weiter" ) )
            )
        )
    );

}

=head4 C<login_failure>

Gibt WML-Deck mit einer Fehlermeldung aus. Seite wird nicht im Cache gespeichert.

=cut
sub login_failure {
    sendwml_nocache(
        card(
            { -title => "nicht angemeldet", -ontimer => "index.pl#login" },
            timer( { -value => "60" } ),
            Do( { -type => "accept" }, go( { -href => "index.pl#login" } ) ),
            p( { -align => "center" }, "Fehler" ),
            p(  { -align => "center" },
                small( "Sie muessen sich neu anmelden!" )
            ),
            p(  { -align => "center" },
                small( a( { -href => "index.pl#login" }, "Login" ) )
            ),
            p(  { -align => "center" },
                small(
                    a(  { -href => "index.pl" },
                        "Mobile Hitchhiker Startseite"
                    )
                )
            )
        )
    );
}

=head4 C<sendwml(@)>

I<Parameter:> WML-Cards (C<(string..)>)

Gibt WML-Deck mit den �bergebenen Cards aus.

=cut
sub sendwml {
    print( $wml->header(), $wml->start_wml(),
        join( "\n", @_ ), $wml->end_wml()
    );
}

=head4 C<sendwml(@)>

I<Parameter:> WML-Cards (C<(string..)>)

Gibt WML-Deck mit den �bergebenen Cards aus.
Deck wird nicht im Cache gespeichert, sondern immer neu geladen.

=cut
sub sendwml_nocache {
    my $now_string = strftime "%a, %d %b %Y %H:%M:%S", gmtime;
    print(
        header(
            -Expires       => 'Mon, 26 Jul 1997 05:00:00 GMT',
            -Last_Modified => "$now_string GMT",
            -Cache_Control => 'no-cache, must-revalidate',
            -Pragma        => 'no-cache',
            -Content_Type  => 'text/vnd.wap.wml'
        ),
        $wml->start_wml(
            -meta => {
                'http-equiv="Cache-Control" content="must-revalidate"' => '',
                'http-equiv="Cache-Control" content="max-age=0"'       => '',
                'http-equiv="Cache-Control" content="no-cache"'        => ''
            }
        ),
        join( "\n", @_ ),
        $wml->end_wml()
    );
}

=head4 C<myparam(@)>

Siehe Dokumentation der C<param>-Methode des C<CGI>-Moduls

=cut
sub myparam {
    return param(@_);
}

1;
