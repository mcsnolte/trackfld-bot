#!/usr/bin/env perl

use X11::GUITest qw/
  StartApp
  WaitWindowViewable
  SetKeySendDelay
  SendKeys
  /;
use Time::HiRes qw/usleep gettimeofday/;

SetKeySendDelay(200);

StartApp(
	'mame',
	'-window',    # not fullscreen
	'trackfld'
);

# Wait for application window to come up and become viewable.
my ($mame_id) = WaitWindowViewable('mame');
if ( !$mame_id ) {
	die("Couldn't find mame window in time!");
}

SendKeys('~');    # skip splash
usleep( 500 * 1000 );
SendKeys('~');

debug("waiting to load...");
usleep( 3000 * 1000 );

debug("adding coins...");
for ( 1 .. 4 ) {
	SendKeys('5');    # add coins
	usleep( 500 * 1000 );
}
SendKeys('1');        # one player
usleep( 500 * 1000 );
SendKeys('1');        # one player again... ugh, key presses are sometimes missed :\

usleep( 500 * 1000 );
debug("entering name...");

# AAA
for ( 1 .. 5 ) {
	SendKeys('%');
	usleep( 200 * 1000 );
}

SetKeySendDelay(100);

# wait to run...
for ( 1 .. 15 ) {
	debug('waiting...');
	usleep( 1010 * 1000 );
}
debug('RUN!');
for ( 1 .. 400 ) {
	SendKeys('^');
}
debug('done running');

sub enter_name {
	for ( 1 .. 13 ) {    # S
		SendKeys('^');
		usleep( 100 * 1000 );
	}
	SendKeys('%');
	usleep( 500 * 1000 );
	for ( 1 .. 4 ) {     # P
		SendKeys('^');
		usleep( 100 * 1000 );
	}
	SendKeys('%');
	usleep( 500 * 1000 );
	for ( 1 .. 2 ) {     # N
		SendKeys('^');
		usleep( 100 * 1000 );
	}
	SendKeys('%');
}

sub debug {
	my ( $seconds, $microseconds ) = gettimeofday;
	printf STDERR ( "[%i.%i] %s\n", $seconds, $microseconds, join( "\n", @_ ) );
}
