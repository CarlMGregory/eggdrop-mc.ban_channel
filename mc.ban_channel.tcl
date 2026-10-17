##
# Ban Channel v3.0.3
#  by MC_8 - Carl M. Gregory <mc8@purehype.net>
#  This script will only run on eggdrop 1.6.14 or greater.
#
#    R.I.P. Mom, To always be remembered; Nancy Marie Gregory.
#
# My Website - http://mc.purehype.net/
# Have a bug?  http://mc.purehype.net/bugzilla/
##

##
# Description
##
# This script will warn/kick/ban users that are found in banned channels.  You
# can specify what channel masks are to be banned on the fly via dcc console.  A
# channel mask, if you don't know, is a glob type masking of the channel name
# (ie:  *cl* could match #tcl or #clown or any other channel name with a cl in
# it).  Of course, you don't have to 'mask' the channel in which you want to
# ban, if you want to ban #tcl -- it's mask would simply be #tcl  (no wild
# cards).
##

##
# Installation
##
# Step 1:
#   Read from the top of this script all the way down to where it says to
#   'Edit no further, tcl coding below.'.  At the very bottom of this script is
#   the history section, if you want to see what's changed from version to
#   version.
#
#   Lines that begin with a # (pound sign) are considered comments, the way
#   of giving the user, you, information within a script such as this.  You
#   don't have to mess with lines that are "commented" because it's only
#   informational and not used by the script in it's functionality.
#
#   Configure things that need to be configured.  Lines that begin with 'set'
#   are considered configurable variables for you to change as needed.  As to
#   what you should set that variable to, read the comment lines before it.  A
#   set is structured in 2 ways.
#   Single line:
#     set Configuration_name "You change this"
#   Multi line:
#     set Configuration_name {
#       You change this.
#       And this too.
#     }
#   In both examples, 'Configuration_name' should never be changed, only what
#   comes after it.  In the single line example, the "" (quotes) should be used
#   at all times (unless you know TCL).
#
#   For single line configuration variable values, you must escape special
#   characters.  But for multi line configuration variable values, you do not
#   escape special characters, unless told otherwise in the commented lines
#   above it.
#   Special characters are any of: ], [, $, ", }, and {
#   What does it mean to escape one of these special characters?
#   To escape something in TCL is to put a \ (back slash) before that character.
#   Example:
#     set Configuration name "You change \"this\"."
#   The example will actually be set correctly (as: You change "this".), but so
#   it doesn't interfere with TCL parsing you must escape it.
#
# Step 2:
#   Ok, step 1 is usually the hard part.  Reading and setting the script's
#   configuration as you need.
#
#   Now, you must load the script into your eggdrop bot.
#   Ensure the configured script is on the same computer the eggdrop runs, then
#   put this line near the bottom of the eggdrop's configuration file:
#     source scripts/filename.tcl
#   Or maybe it's located somewhere other than the scripts directory within the
#   eggdrop directory:
#     source /full/path/to/filename.tcl
#
#   Cool, now it's in the configuration file, just do '.rehash' within dcc chat
#   with your eggdrop.  You should see that it either loaded or didn't on the
#   screen after you type that rehash command.
#
# Note:
#   To remove a script, or unload a script, from eggdrop you simply remove the
#   'source' of that script from eggdrop's configuration file then do the
#   '.restart' command in dcc chat with the bot.  You have to do a .restart,
#   .rehash will not do it.  Rehash reloads everything, but does not clear
#   memory before hand.  Restart clears the memory then reloads everything,
#   hence clearing the script from memory.
##

##
# Commands
##
# DCC:
#   ban_channels [channel|'global'|'all']
#     This will show you a list of banned channels for the particular channel.
#     If [channel|'global'|'all'] is not specified, it will default to 'all'.
#
#   ban_channels scan [channel|nick]
#     This will force the bot to scan all users on the specified channel.  If no
#     [channel|nick] is specified, then it will scan all channels.  If it turns
#     out that the nick you give is not on any channels the bot is on, it will
#     convert over to scan all channels instead.
#
#   +ban_channel [channel|'global'] <banned_channel> [reason]
#     This will add a new channel ban either globally or to a specific channel.
#     banned_channel can be masked any way you wish, using glob formatting:
#       http://tcl.activestate.com/man/tcl8.4/TclCmd/string.htm#M35
#     If [channel|'global'] is exempt, global is assumed.
#
#   -ban_channel [channel|'global'] <banned_channel>
#     This will remove a channel ban from the global list or a specific channel.
#     If [channel|'global'] is not given, it will default to global.
#
#   chanset <channel> <+/->mc.ban_channel
#     This will either enable (+) or disable (-) the script for the specified
#     channel.  By default, channels are disabled until otherwise set.
#
#   chanset <channel> mc.ban_channel.warnings <number>
#     How many warnings you want to give a user about being in a banned channel
#     is set here.  You can set this to 0, will logically give no warnings.
#
#   chanset <channel> <+/->mc.ban_channel.exempt.ops
#     You can set this to exempt, +, physical ops from reaction of this script
#     for the specific channel.
#
#   chanset <channel> <+/->mc.ban_channel.exempt.voices
#     You can set this to exempt, +, physical voices from reaction of this
#     script for the specific channel.
#
#   chanset <channel> mc.ban_channel.exempt.flags <flags>
#     You can set this to exempt users based on there flags from reaction of
#     this script for the specific channel.
#
#   chanset <channel> mc.ban_channel.scan_time <seconds>
#     You can set how long to wait before scanning the user for banned channels.
#     You can set the value to 0 for 0 seconds, will cause the script to scan as
#     soon as he/she join's the channel. This is a good way to ensure you only
#     scan the users that decide they want to be a part of the channel, unlike
#     those that join then part within a second or so. If this is set to 0 and
#     a user join's then parts 1 second later, the scan will be done, but since
#     the user is no longer in the channel then the scan was pointless and
#     further lags the bot.
#
#   chanset <channel> mc.ban_channel.rescan_time <minutes>
#     How often do you want to re-scan the users of the specified channel to see
#     if they have joined a banned channel?  Setting this to 0, for 0 minutes,
#     will disable the re-scan function, therefor users only get scanned upon
#     joining the channel (they can join banned channels only after, never
#     before, they join this one).
#
# <banned_channel> for the add/remove can contain wild cards, incase you want to
# ban certain words in channels names.  Ie. *pre*teen*  *sex*  or whatever.
##

##
# Configuration
##
#

# What flagged users are able to utilize the 'ban_channels' DCC command?  Set
# this to "-|-" to allow anyone to access the command (provided they can DCC
# chat the bot).
set mc_banc(:config:access:ban_channels) "-|-"

# What flagged users are able to utilize the '+ban_channel' DCC command?  Set
# this to "-|-" to allow anyone to access the command (provided they can DCC
# chat the bot).
set mc_banc(:config:access:+ban_channel) "m|m"

# What flagged users are able to utilize the '-ban_channel' DCC command?  Set
# this to "-|-" to allow anyone to access the command (provided they can DCC
# chat the bot).
set mc_banc(:config:access:-ban_channel) "m|m"

# If a user is found in a banned channel, this script can do two command sets.
# The first one is the warning command set, and the second one is the excessive
# warnings command set. If the user still has a warning left, warning command
# set is done, otherwise excessive warnings command set is done. The number of
# warnings are set in via dcc chanset command, see the Commands section (above).
# Separate each command with a new line.
# Valid commands are:
#   /msg <nick|channel> <text>
#   /notice <nick|channel> <text>
#   /ban <channel> [%<time>] [*<banmask_type>] [reason]
#     time:
#       If time is specified;
#         -1 = Server ban.
#          0 = Perm ban.
#         Any number greater than 0 is the ban expiration in min's.
#       If the time specified is not a server ban, the reason will be put into
#       the bot's internal ban list record as the reason for adding the ban.
#       Otherwise the ban is considered a server ban and reason is just ignored.
#       When you specify time, don't forget the % (ie: %20 is 20 minutes). In
#       addition to the time of the ban, you can set it to be sticky (read up
#       on '.help stick'). To make the ban sticky; append the time with a '!'
#       (exclamation point) (ie: %20! is 20 minute sticky ban).
#       This setting is optional, if not given then it will default to -1
#       (server ban).
#     banmask_type:
#       This will mask the users ban to the banmask_type number you
#       give. Don't forget the * when you specify the number (ie: *19 is banmask
#       type number 19).
#       Banmask types are:
#        -1 - nick!*@*
#         0 - *!user@host.domain
#         1 - *!*user@host.domain
#         2 - *!*@host.domain
#         3 - *!*user@*.domain
#         4 - *!*@*.domain
#         5 - nick!user@host.domain
#         6 - nick!*user@host.domain
#         7 - nick!*@host.domain
#         8 - nick!*user@*.domain
#         9 - nick!*@*.domain
#         You can also specify a type of 10 to 19 which correspond to masks 0 to
#         9.
#         But if the host.domain is a;
#           hostname = Instead of using a * wildcard to replace portions of the
#                      host.domain, it replaces the numbers in the host.domain
#                      with a '?' (question mark) wildcard.
#           ip       = It will mask as normal, with no '?' (question mark)
#                      replacements as does hostname.
#       This setting is optional, if not given then it will default to type 3.
#   /kick <channel> [reason]
#     If no reason is given, the script's name and version will be used.
#   /rescan <second>
#     This will have the script rescan the user in the specified second.
#     Normal use, used within a warning command set to ensure the user has
#     in fact left the banned channel.
#   /set_warning [number]
#     You can use this to reset the users current number of warnings to the
#     number given.  If you exempt the number, 0 will be assume -- effectively
#     resetting the warnings back to 0 (none).  Some people want to reset a
#     users warning number upon doing an excessive warnings command set as so
#     next time they are detected in a banned channel they will be warned again
#     instead of immediately being processed by the excessive warning command
#     set, and some do not.  I'll let the user decide by giving them this
#     command option.
#   /putlog <text>
#     This will dump <text> to the 'o' (other) console. Don't know what this is
#     exactly?  Play with it, you can't hurt anything.
#   /putlog_d <text>
#     This will dump <text> to the 'd' (debug) console. Don't know what this is
#     exactly?  Play with it, you can't hurt anything.
#   /raw <raw_irc_code>
#     See: http://www.user-com.undernet.org/documents/rfc1459.txt
#     Examples:
#       Deop:    /raw MODE %channel% -o %nick%
#       Devoice: /raw MODE %channel% -v %nick%
#   /tcl <coding>
#     This is for users that are somewhat failure with the TCL language, for a
#     somewhat more advanced way of process commands.  In addition to /tcl, I
#     have made tcl commands out of /msg, /notice, /ban, /kick, /rescan,
#     /set_warning, /putlog, /putlog_d, and /raw.
#     Examples:
#       Deop user only if opped;
#         /tcl if {[isop %nick% %channel%]} {/raw MODE %channel% -o %nick%}
#       Give users different warning messages depending on the current number of
#       warnings the user has received;
#         /tcl if {%warnings% == "0"} {/msg %nick% Leave %banned_channel%.}
#         /tcl if {%warnings% == "1"} {/msg %nick% You must leave that channel.}
#         /tcl if {%warnings% >= "2"} {/msg %nick% Your gonna get banned...}
# Replacement variables:
#   %nick%           - IRC nickname of the user that is in violation (last to
#                      trigger evaluation).
#   %channel%        - The channel that doesn't want this 'banned channel'
#                      associated with (simply put, the channel the user just
#                      joined).
#   %warning_limit%  - Maximum number of warnings allowed.
#   %warnings%       - Current number of warnings the user has received,
#                      counting this one.
#   %banned_mask%    - The banned channel mask the user triggered when being
#                      scanned.
#   %banned_channel% - The banned channel that was found with the banned
#                      channel mask (the exact channel name of the channel in
#                      question).
#   %reason%         - The reason for the banned channel mask, specified when
#                      the ban channel mask is added via dcc command.

# Warning command set:
set mc_banc(:config:warning_command_set) {
  /putlog Ban Channel: Found %nick%@%channel% in %banned_channel%, warning.

  /rescan 60
  /putlog_d Ban Channel: Re scanning %nick% in 60 seconds.

  /msg %nick% You have 1 min. to leave %banned_channel%.
  /putlog_d Ban Channel: [Msg %nick%] You have 1 min. to leave %banned_channel%.

  /msg %nick% Non cooperation will result in a ban.
  /putlog_d Ban Channel: [Msg %nick%] Non cooperation will result in a ban.
}

# Excessive warnings command set:
set mc_banc(:config:excessive_warnings_command_set) {
  /putlog Ban Channel: Found %nick%@%channel% in %banned_channel%, kick/banning.

  /ban %channel% %5 *3 %reason%
  /putlog_d Ban Channel: Banned %nick% on %channel% for 5 minutes.

  /kick %channel% %reason%
  /putlog_d Ban Channel: Kicked %nick% from %channel%.

  /msg %nick% You were warned to leave %banned_channel%.
  /putlog_d Ban Channel: [Msg %nick%] You were warned to leave %banned_channel%.

  /set_warning 0
  /putlog_d Ban Channel: Reset warnings for %nick% on %channel%
  /putlog_d Ban Channel: regarding %banned_channel%.
}

# This script will accumulate data. That data is to be stored into a data
# file. Where and what do you want to call that file?
set mc_banc(:config:datafile) "./.badc.data"

## SVS Client (Script Version Service) v4.1.3 ##
# Once a day, the SVS Client will connect to MC_8's SVS Server to determine if
# there is a newer version of this script available.  If a newer version is
# found, the script will be auto updated.

# [0=no/1=yes] Do you want to enable auto updating?  If you chose to disable
# auto updating, it will not automatically update the script upon finding a
# newer version.
set mc_banc(:config:svs:enable) 1

#
##


##
# Edit no further, tcl coding below.
##
#

## SVS insert (pre code)
#Script:mc_banc
catch {unset temp}

foreach temp(bind) [binds mc:banc:*] {
  foreach {temp(1) temp(2) temp(3) temp(4) temp(5)} $temp(bind) break
  catch {unbind $temp(1) $temp(2) $temp(3) $temp(5)}
}

foreach temp(bind) [binds mc:bc:*] {
  foreach {temp(1) temp(2) temp(3) temp(4) temp(5)} $temp(bind) break
  catch {unbind $temp(1) $temp(2) $temp(3) $temp(5)}
}

foreach temp(command) [info commands mc:bc:*] {
  rename $temp(command) ""
}

set mc_banc(info:vars) ""
foreach {temp(name) temp(value)} [array get mc_banc :config:*] {
  lappend mc_banc(info:vars) [list $temp(name) $temp(value)]
}
set mc_banc(info:loc) [info script]
array set mc_banc [list \
  script                 "Ban Channel" \
  version                "v3.0.3" \
  svs:script             "banchan" \
  svs:version            "003000003000" \
  svs:client_version     "v4.1.3" \
  svs:client_svs_version "004001003000" \
  svs:server             "mc.svs.purehype.net" \
  svs:port               "80" \
  svs:get                "/index.tcl"]
set mc_banc(svs:query)    "svs=$mc_banc(svs:script)&"
append mc_banc(svs:query) "version=$mc_banc(svs:version)&"
append mc_banc(svs:query) \
  "svs_version=$mc_banc(svs:client_svs_version)"

if {![info exists numversion] ||
    ([string range $numversion 0 4] < "10614") ||
    (([string range $numversion 0 4] == "10614") &&
     ([string range $numversion 5 6] != "00"))} {
  set temp(tag) "$mc_banc(script) $mc_banc(version)"
  putloglev o * \
    "$temp(tag) by MC_8 will only work on eggdrop 1.6.14 (stable) or greater."
  putloglev o * "$temp(tag) will not work with eggdrop $version."
  putloglev o * "$temp(tag) not loaded."
  uplevel #0 {
    if {[info exists temp] && ![array exists temp]} {unset temp}
    set temp(svs_return) [list 0 "Need to upgrade eggdrop."]
  }; return 1
}
## ^

# Error Catching System (ECS), v4.1.
proc mc:banc:errchk {command args} {

  # Enable (1) or disable (0) auto reporting of bugs to mc8@purehype.net.
  # This setting here for those who want to disable it in fear of privacy
  # violations.
  set enable_auto_reporting 1

  if {![info exists ::lastCommand]} {set ::lastCommand [list]}
  set ::lastCommand \
    "[list [list [clock seconds] $command $args]] $::lastCommand"
  set ::lastCommand [lrange $::lastCommand 0 4]
  if {![catch {eval $command $args} return]} {return $return}
  if {$::errorCode == "mc.ecs.done"} {return -errorcode mc.ecs.done -code error}

  set temp(lastbind) [expr {[info exists ::lastbind]?$::lastbind:"-NULL-"}]
  set temp(eversion) [expr {[info exists ::version]?$::version:"-NULL-"}]
  set message "
    ************************************
    (ECS 4.1) Error found in TCL script.
    --------------
    Script name   : $::mc_banc(script)
    Script version: $::mc_banc(version)
    Egg. Version  : $temp(eversion)
    TCL Version   : [info tclversion] ([info patchlevel])
    --------------
    Last Bind     : $temp(lastbind)
    Last Commands :"
  foreach line $::lastCommand {
    foreach {time command arg} $line break
    append message "\n        ${time}- $command $arg"
  }
  append message "\n    Error stack   :"
  foreach line [split $::errorInfo \n] {
    append message "\n        $line"
  }
  append message "\n    --------------"

  set message [lrange [split $message \n] 1 end]
  set offset [string first * [lindex $message 0]]
  set new_message [list]
  foreach line $message {lappend new_message [string range $line $offset end]}
  set message $new_message

  if {!$enable_auto_reporting ||
      [catch {socket -async mc.purehype.net 80} sid]} {
    foreach line $message {putloglev o * $line}
    putloglev o * "Submit this bug to http://mc.purehype.net/bugzilla/ . If"
    putloglev o * "you are experiencing problems with bugzilla, contact MC_8"
    putloglev o * "via email at mc8@purehype.net. Please include all"
    putloglev o * "information shown here, in this ECS report."
    putloglev o * "************************************"
    return -errorcode mc.ecs.done -code error
  }
  fconfigure $sid -blocking 0 -buffering line

  set query [list]
  # This info is passed should I need to hunt down the bot's owner for more
  # information.
  lappend query "Admin   : [expr {[info exists ::admin]?$::admin:""}]"
  lappend query "Owner   : [expr {[info exists ::owner]?$::owner:""}]"
  lappend query "Botnick : [expr {[info exists ::botnick]?$::botnick:""}]"
  lappend query "Server  : [expr {[info exists ::server]?$::server:""}]"
  lappend query "Channels: [join [lsort -dictionary [channels]] ", "]"
  lappend query ""

  foreach line $message {lappend query $line}
  lappend query "************************************"

  set new_query [list]
  foreach line $query {
    regsub -all -- "(\002|\017|\026|\037)" $line "" line
    regsub -all -- "\003(\[0-9\]\[0-9\]?(,\[0-9\]\[0-9\]?)?)?" $line "" line
    regsub -all {\%} $line "%25" line
    set i [string length $line]
    while {[regexp {[^a-zA-Z0-9%]} $line toh] && ($i >= 0)} {
      scan "$toh" %c dec
      regsub -all -- "\\${toh}" $line "%[format %X $dec]" line
      incr i -1
    }; lappend new_query $line
  }; set query $new_query

  set query "message=[join $query %0a]"
  puts $sid "POST /report_bug.tcl HTTP/1.0\
           \nHost: mc.purehype.net:80\
           \nContent-type: application/x-www-form-urlencoded\
           \nContent-Length: [expr [string length $query] +2]"
  puts $sid \n$query
  close $sid

  foreach line $message {putloglev o * $line}
  putloglev o * "Automatically sending bug report to MC_8."
  putloglev o * "If you have a firewall setup, it may block the sending of this"
  putloglev o * "report. You can check the status of your bug, as soon as MC_8"
  putloglev o * "adds it, at http://mc.purehype.net/bugzilla/ ."
  putloglev o * "************************************"

  return -errorcode mc.ecs.done -code error
}
# ^

setudef flag mc.ban_channel
setudef flag mc.ban_channel.exempt.ops
setudef flag mc.ban_channel.exempt.voices
setudef str  mc.ban_channel.exempt.flags
setudef int  mc.ban_channel.scan_time
setudef int  mc.ban_channel.rescan_time
setudef int  mc.ban_channel.warnings

foreach {temp(array_name) temp(array_value)} [list \
  access:ban_channels            -|- \
  access:+ban_channel            m|m \
  access:-ban_channel            m|m \
  warning_command_set            "/putlog $mc_banc(script): NO COMMANDS SET!" \
  excessive_warnings_command_set "/putlog $mc_banc(script): NO COMMANDS SET!" \
  datafile                       ./.banc.data] {
  if {[info exists mc_banc(:config:$temp(array_name))]} {continue}
  # Note, I user 'array set' instead of 'set' as so the SVS auto update won't
  # fuck with it.
  array set mc_banc [list :config:$temp(array_name) $temp(array_value)]
  set temp() "Warning, \"$temp(array_name)\""
  append temp() " (set mc_banc(:config:$temp(array_name))) was not set"
  append temp() "  -- defaulting to \"$temp(array_value)\""
  putloglev o * "$mc_banc(script): $temp()"
}

# ban_channels [channel|'global'|'all']
# ban_channels scan [channel]
bind dcc - ban_channels mc:banc:dcc:ban_channels
proc mc:banc:dcc:ban_channels {handle index arg} {
  return [mc:banc:errchk mc:banc:dcc:ban_channels_ $handle $index $arg]
}
proc mc:banc:dcc:ban_channels_ {handle index arg} {
  global mc_banc

  set arg [split $arg]
  set channel [lindex $arg 0]
  if {$channel == "scan"} {
    return [mc:banc:dcc:ban_channels:scan $handle $index [lindex $arg 1]]
  }; if {$channel == ""} {set channel "all"}

  if {![mc:banc:list has_dcc_access $handle $channel ban_channels]} {
    putloglev c * "#$handle# (denied) ban_channels $channel"
    putdcc $index "Access denied."
    return 0
  }

  set list [mc:banc:list list $channel]
  set list [lsort -dictionary -index 1 $list]
  set list [lsort -dictionary -index 0 $list]

  set format_length 10
  foreach item $list {
    foreach {channel banned_channel reason} $item break
    lappend cache($channel) [list $banned_channel $reason]
    set current_format_length [string length $banned_channel]
    if {$current_format_length > $format_length} {
      set format_length $current_format_length
    }
  }

  foreach channel [array names cache] {
    if {$channel == "global"} {set enabled ""} \
    elseif {![validchan $channel] ||
            ![channel get $channel mc.ban_channel]} {
      set enabled " (script disabled for this channel)"
    } else {set enabled ""}

    putdcc $index "$channel$enabled:"
    foreach entry $cache($channel) {
      foreach {banned_channel reason} $entry break
      putdcc $index [format "     %-${format_length}s   Reason: %s" \
        $banned_channel $reason]
    }
  }
  return 1
}

# ban_channels scan [channel|nick]
proc mc:banc:dcc:ban_channels:scan {handle index channel} {
  return [mc:banc:errchk mc:banc:dcc:ban_channels:scan_ $handle $index $channel]
}
proc mc:banc:dcc:ban_channels:scan_ {handle index channel} {
  global mc_banc

  set user_scan 0
  if {[onchan $channel]} {
    set nick $channel
    set channel "all"
    set user_scan 1
  } elseif {![validchan $channel]} {
    set channel "all"
  }

  if {![mc:banc:list has_dcc_access $handle $channel ban_channels]} {
    if {$user_scan} {set channel $nick}
    putloglev c * "#$handle# (denied) ban_channels scan $channel"
    putdcc $index "Access denied."
    return 0
  }

  putdcc $index "Scanning..."

  if {$user_scan && [mc:banc:list has_bans $channel]} {
    mc:banc:list scan $nick $channel
    return 1
  }

  if {$channel == "all"} {set channels [channels]} \
  elseif {![validchan $channel]} {
    putdcc $index "Invalid channel: $channel"
    return 0
  } else {
    if {![channel get $channel mc.ban_channel]} {
      putdcc $index "The script is disabled for that channel."
      return 0
    }
    if {![mc:banc:list has_bans $channel]} {
      set temp() "There are no bans setup for that channel"
      putdcc $index "$temp(), no need to waste bandwidth by doing a scan."
      return 0
    }
    set channels [list $channel]
  }

  foreach channel $channels {
    if {![validchan $channel] ||
        ![channel get $channel mc.ban_channel] ||
        ![mc:banc:list has_bans $channel]} {continue}

    foreach nick [chanlist $channel] {
      if {[info exists buffer($nick)]} {continue}
      set buffer($nick) 1

      mc:banc:list scan $nick $channel
    }
  }

  return 1
}

#   +ban_channel [channel|'global'] <banned_channel> [reason]
bind dcc - +ban_channel mc:banc:dcc:+ban_channel
proc mc:banc:dcc:+ban_channel {handle index arg} {
  return [mc:banc:errchk mc:banc:dcc:+ban_channel_ $handle $index $arg]
}
proc mc:banc:dcc:+ban_channel_ {handle index arg} {
  global mc_banc

  set i 0; set arg [split $arg]
  set channel [lindex $arg $i]
  if {![validchan $channel] && ($channel != "global")} {
    set channel "global"
  } else {incr i}
  set banned_channel [lindex $arg $i]; incr i
  set reason [join [lrange $arg $i end]]

  if {![mc:banc:list has_dcc_access $handle $channel +ban_channel]} {
    set temp() "#$handle# (denied) +ban_channel $channel"
    append temp() " $banned_channel $reason"
    putloglev c * $temp()
    putdcc $index "Access denied."
    return 0
  }

  if {$banned_channel == ""} {
    set temp() {Usage: +ban_channel [channel|'global']}
    append temp() { <banned_channel> [reason]}
    putdcc $index $temp()
    return 0
  }

  if {![mc:banc:list add $channel $banned_channel $reason]} {
    putdcc $index "Ban channel entry already exists."
    return 0
  }

  putdcc $index \
    "Added $banned_channel ($reason) to $channel's ban channel list."
  return 1
}

#   -ban_channel [channel|'global'] <banned_channel>
bind dcc - -ban_channel mc:banc:dcc:-ban_channel
proc mc:banc:dcc:-ban_channel {handle index arg} {
  return [mc:banc:errchk mc:banc:dcc:-ban_channel_ $handle $index $arg]
}
proc mc:banc:dcc:-ban_channel_ {handle index arg} {
  global mc_banc

  set i 0; set arg [split $arg]
  set channel [lindex $arg $i]
  if {![validchan $channel] && ($channel != "global")} {
    set channel "global"
  } else {incr i}
  set banned_channel [lindex $arg $i]

  if {![mc:banc:list has_dcc_access $handle $channel -ban_channel]} {
    putloglev c * "#$handle# (denied) -ban_channel $channel $banned_channel"
    putdcc $index "Access denied."
    return 0
  }

  if {$banned_channel == ""} {
    putdcc $index {Usage: -ban_channel [channel|'global'] <banned_channel>}
    return 0
  }

  if {![mc:banc:list remove $channel $banned_channel]} {
    putdcc $index "No such ban channel entry."
    return 0
  }

  putdcc $index "Removed $banned_channel from $channel's ban channel list."
  return 1
}

bind join - * mc:banc:join
proc mc:banc:join {nick uhost handle channel} {
  return [mc:banc:errchk mc:banc:join_ $nick $uhost $handle $channel]
}
proc mc:banc:join_ {nick uhost handle channel} {
  global mc_banc

  if {[isbotnick $nick]} {
    set mc_banc([list :enable: [string tolower $channel]]) 1
    return 0
  }

  if {![channel get $channel mc.ban_channel] ||
      ![mc:banc:list has_bans $channel]} {return 0}
  set exempt_flags [channel get $channel mc.ban_channel.exempt.flags]
  if {($exempt_flags != "-|-") && [matchattr $handle $exempt_flags $channel]} {
    return 0
  }

  mc:banc:list scan $nick $channel \
    [channel get $channel mc.ban_channel.scan_time]
  return 1
}

bind raw - 001 mc:banc:raw
bind raw - 005 mc:banc:raw
bind raw - 315 mc:banc:raw
bind raw - 319 mc:banc:raw
proc mc:banc:raw {from key arg} {
  return [mc:banc:errchk mc:banc:raw_ $from $key $arg]
}
proc mc:banc:raw_ {from key arg} {
  global mc_banc

  switch -- $key {

    "001" {
      if {[info exists ::serverSupport]} {unset ::serverSupport}
    }

    "005" {
      foreach item [lrange [split $arg] 1 end] {
        if {[string match :* $item]} {break}
        foreach {name value} [split $item =] break
        set ::serverSupport($name) $value
      }
    }

    "315" {
      #315> telnet #abc123 :End of /WHO list.
      foreach {to channel} [split $arg] break

      if {![isbotnick $to]} {return 0}

      set array [list :enable: [string tolower $channel]]
      if {![info exists mc_banc($array)]} {return 0} \
      else {unset mc_banc($array)}

      if {![channel get $channel mc.ban_channel] ||
          ![mc:banc:list has_bans $channel]} {return 0}

      set exempt_flags [channel get $channel mc.ban_channel.exempt.flags]

      foreach nick [chanlist $channel] {
        if {[isbotnick $nick] ||
            (($exempt_flags != "-|-") &&
             [matchattr [nick2hand $nick $channel] $exempt_flags $channel]) ||
            [info exists buffer($nick)]} {
          continue
        }
        set buffer($nick) 1

        mc:banc:list scan $nick $channel
      }
    }

    "319" {
      #319> telnet MC_8 :#mp34free #ftpwarez #abc123 @#tcl @#eggdrop
      #319> telnet Eggdrop :-@#tcl
      set arg [split $arg]
      foreach {to nick} $arg break
      set args [lrange $arg 2 end]
      set handle [nick2hand $nick]
      regexp -- {^:?(.*)$} [join $args] -> channels
      set channels [split $channels]

      if {![isbotnick $to] || [isbotnick $nick] || ($handle == "")} {return 0}
      set uhost [getchanhost $nick]
      set host [lindex [split $uhost @] end]

      # Note:  There is no standards for 005, yet (I hope yet).  Furthermore, is
      #        no standard, that I saw, stating that a PREFIX can or cannot be
      #        the same as a CHANTYPE.
      #        Example:
      #          1) #eggdrop is a channel type of #
      #          2) give user +o gives @
      #          3) Whois of user shows channel as @#eggdrop.
      #          -----
      #          1) #eggdrop has a channel type of #
      #          2) to give +(something) gives #
      #          3) Whois of user shows channel as ##eggdrop.
      #        If that second example holds true on the irc server this
      #        script runs, it will break the script. After discussing this with
      #        Paladin, we came to the conclusion (based on lack of
      #        documentation of the standards) that we just to have faith that
      #        the second example will never hold true.
      #
      # Before I used to just trimleft -+@%, but if other servers used something
      # different I would have to update the script.  Who knows, due to there
      # being no standard way servers act -- I may have to go back to that
      # method.
      if {![info exists ::serverSupport(CHANTYPES)]} {set CHANTYPES "#&"} \
      else {set CHANTYPES $::serverSupport(CHANTYPES)}

      set list [list]
      foreach channel $channels {
        set index [string length $channel]
        foreach CHANTYPE [split $CHANTYPES ""] {
          set current_index [string first $CHANTYPE $channel]
          if {($current_index < $index) &&
              ($current_index != "-1")} {set index $current_index}
        }
        if {$index == [string length $channel]} {set index 0}
        lappend list [string tolower [string range $channel $index end]]
      }
      set channels $list

      foreach channel [channels] {
        if {![onchan $nick $channel] ||
            ![channel get $channel mc.ban_channel] ||
            ![mc:banc:list has_bans $channel]} {continue}

        set exempt_flags  [channel get $channel mc.ban_channel.exempt.flags]
        set exempt_ops    [channel get $channel mc.ban_channel.exempt.ops]
        set exempt_voices [channel get $channel mc.ban_channel.exempt.voices]
        if {(($exempt_flags != "-|-") &&
             [matchattr $handle $exempt_flags $channel]) ||
            ($exempt_ops && [isop $nick $channel]) ||
            ($exempt_voices && [isvoice $nick $channel])} {continue}

        set warning_limit [channel get $channel mc.ban_channel.warnings]
        set lchannel [string tolower $channel]
        set buffer [list]

        set list [list]
        foreach entry [mc:banc:list list global  ] {lappend list $entry}
        foreach entry [mc:banc:list list $channel] {lappend list $entry}
        foreach entry $list {
          foreach {"" banned_channel reason} $entry break

          set index [lsearch -glob $channels $banned_channel]
          if {$index == "-1"} {continue}
          set banned_channel_match [lindex $channels $index]
          if {[lsearch -exact $buffer $banned_channel_match] > "-1"} {
            # We already processed an action for the matched channel during
            # this scan.
            continue
          }; lappend buffer $banned_channel_match
          set lbanned_channel_match [string tolower $banned_channel_match]

          # Determine if within warning command set or not.
          set array [list :warnings: $host $lchannel $lbanned_channel_match]
          if {![info exists mc_banc($array)]} {set mc_banc($array) 0}
          incr mc_banc($array)

          if {$mc_banc($array) > $warning_limit} {
            # Excessive warnings command set.
            incr mc_banc($array) -1
            mc:banc:list process_actions \
              $mc_banc(:config:excessive_warnings_command_set) $nick $channel \
              $warning_limit $mc_banc($array) $banned_channel \
              $banned_channel_match $reason

          } else {
            # Warning command set.
            mc:banc:list process_actions $mc_banc(:config:warning_command_set) \
              $nick $channel $warning_limit $mc_banc($array) $banned_channel \
              $banned_channel_match $reason

          }
        }
      }
    }

  }
  return 0
}

bind evnt - save mc:banc:evnt:save
proc mc:banc:evnt:save {type} {
  return [mc:banc:errchk mc:banc:evnt:save_ $type]
}
proc mc:banc:evnt:save_ {type} {
  mc:banc:list save
}

# Ensure rescan timers are always running.
proc mc:banc:check_timers {} {
  return [mc:banc:errchk mc:banc:check_timers_]
}
proc mc:banc:check_timers_ {} {
  set utimers [utimers]
  foreach channel [channels] {
    set channel [string tolower $channel]
    set command [list mc:banc:rescan_timer $channel]

    if {![channel get $channel mc.ban_channel]} {continue}
    set rescan_time [channel get $channel mc.ban_channel.rescan_time]
    if {!$rescan_time} {continue}
    set rescan_time [expr $rescan_time*60]
    if {[lindex [split [expr $rescan_time/2.] .] 1]} {incr rescan_time}

    set found 0
    foreach utimer $utimers {
      foreach {t_time t_command t_id} $utimer break
      if {$command == $t_command} {
        if {$t_time > $rescan_time} {killutimer $t_id} \
        else {set found 1}
        break
      }
    }
    if {!$found} {utimer $rescan_time $command}
  }

  set command [list mc:banc:check_timers]
  set found 0
  foreach utimer $utimers {
    foreach {t_time t_command t_id} $utimer break
    if {$command == $t_command} {
      set found 1
      break
    }
  }
  if {!$found} {utimer 60 $command}
}; utimer 2 [list mc:banc:check_timers]

proc mc:banc:rescan_timer {channel} {
  return [mc:banc:errchk mc:banc:rescan_timer_ $channel]
}
proc mc:banc:rescan_timer_ {channel} {
  set channel [string tolower $channel]
  set command [list mc:banc:rescan_timer $channel]
  set utimers [utimers]

  if {![validchan $channel] || ![channel get $channel mc.ban_channel]} {return}
  set rescan_time [channel get $channel mc.ban_channel.rescan_time]
  if {!$rescan_time} {return}
  set rescan_time [expr $rescan_time*60]
  if {[lindex [split [expr $rescan_time/2.] .] 1]} {incr rescan_time}

  set found 0
  foreach utimer $utimers {
    foreach {t_time t_command t_id} $utimer break
    if {$command == $t_command} {
      if {$t_time > $rescan_time} {killutimer $t_id} \
      else {set found 1}
      break
    }
  }
  if {!$found} {utimer $rescan_time $command}

  foreach nick [chanlist $channel] {
    if {[info exists buffer($nick)]} {continue}
    set buffer($nick) 1

    mc:banc:list scan $nick $channel
  }
}

foreach temp(command) [list /msg /notice /ban /kick /rescan \
                            /set_warning /putlog /putlog_d /raw] {
  proc $temp(command) {{args ""}} "
    mc:banc:list process_actions \"$temp(command) \[join \$args\]\"
  "
}

proc mc:banc:list {command {args ""}} {
  return [mc:banc:errchk mc:banc:list_ $command $args]
}
proc mc:banc:list_ {command arg} {
  global mc_banc
  set args $arg

  switch -- $command {

    "has_dcc_access" {
      foreach {handle channel type} $args break

      if {$mc_banc(:config:access:$type) == "-|-"} {return 1}
      if {![validchan $channel]} {
        set flag [lindex [split $mc_banc(:config:access:$type) |] 0]
        return [matchattr $handle $flag]
      } else {
        return [matchattr $handle $mc_banc(:config:access:$type) $channel]
      }
    }

    "has_bans" {
      set channel [string tolower [lindex $args 0]]

      return [expr {([llength [mc:banc:list list $channel]])?"1":
                    ([llength [mc:banc:list list global]])?"1":"0"}]
    }

    "scan" {
      # Returns:
      #  0 -- Doesn't have bans or is botnick
      #  1 -- Doing scan now.
      #  2 -- Setup in timers.
      #  3 -- User not on channel.
      # Note 'channel' can be a channel or 'all'.
      foreach {nick channel when} $args break
      if {![info exists when] || ($when == "")} {set when 0}
      set nick [string tolower $nick]
      set channel [string tolower $channel]

      if {[isbotnick $nick] || ![mc:banc:list has_bans $channel]} {return 0}

      set command [list mc:banc:list scan $nick $channel]
      set utimers [utimers]

      if {$when} {
        # Note, yes -- is possible multi timers are set.  Say if user joins 3
        # channels the bot monitors.  To avoid being scanned multi times when
        # really only once is needed, upon passing the on channel test all
        # timers that are setup to scan the user are killed.  Should he fail is
        # on channel test, the other timers are still going incase he is in the
        # channel on one of them timers.
        if {[lindex [split [expr $when/2.] .] 1]} {incr when}
        utimer $when $command
        return 2
      }

      # On channel test.
      if {(($channel == "all") && ![onchan $nick]) ||
          ([validchan $channel] && ![onchan $nick $channel]) ||
          (($channel != "all") && ![validchan $channel])} {
        return 3
      }

      # Passed on channel, kill all timers asking for $nick to be scanned
      # (regardless of the channel argument).
      foreach utimer $utimers {
        if {[lsearch -glob $utimer [list mc:banc:list scan $nick *]] == "1"} {
          killutimer [lindex $utimer 2]
        }
      }

      putserv "WHOIS $nick"
      return 1
    }

    "add" {
      foreach {channel banned_channel reason} $args break
      set channel [string tolower $channel]
      set banned_channel [string tolower $banned_channel]

      set array [list :list:]

      regsub -all -- {([][*?\\])} $channel        {\\\1} channel_
      regsub -all -- {([][*?\\])} $banned_channel {\\\1} banned_channel_
      set search [list $channel_ $banned_channel_ *]
      if {[lsearch -glob $mc_banc($array) $search] >= "0"} {
        # Entry already exists.
        return 0
      }

      lappend mc_banc($array) [list $channel $banned_channel $reason]
      return 1
    }

    "remove" {
      foreach {channel banned_channel} $args break
      set channel [string tolower $channel]
      set banned_channel [string tolower $banned_channel]

      set array [list :list:]

      regsub -all -- {([][*?\\])} $channel        {\\\1} channel_
      regsub -all -- {([][*?\\])} $banned_channel {\\\1} banned_channel_
      set search [list $channel_ $banned_channel_ *]
      if {[set ls [lsearch -glob $mc_banc($array) $search]] == "-1"} {
        # Entry doesn't exist.
        return 0
      }

      set mc_banc($array) [lreplace $mc_banc($array) $ls $ls]
      return 1
    }

    "list" {
      # Note: Input can be channel global or all (or blank for all).
      set channel [string tolower [lindex $args 0]]
      if {$channel == ""} {set channel "all"}

      set array [list :list:]
      set return [list]

      foreach entry $mc_banc($array) {
        if {($channel == "all") || ([lindex $entry 0] == $channel)} {
          lappend return $entry
        }
      }
      return $return
    }

    "process_actions" {
      # Note: actions should be separated by \n's, not in list format.
      foreach {actions nick channel warning_limit warnings banned_mask \
        banned_channel reason} $args break
      foreach item [list actions nick channel warning_limit warnings \
        banned_mask banned_channel reason] {
        if {![info exists $item]} {set $item ""}
      }

      set new_actions [list]
      foreach action [split $actions \n] {
        set action [string trim $action "\t "]
        if {($action == "") || [string match #* $action]} {continue}
        lappend new_actions $action
      }; set actions $new_actions

      foreach action $actions {

        set action [mc:banc:replace -- $action [list\
          %channel%        $channel        \
          %nick%           $nick           \
          %warning_limit%  $warning_limit  \
          %warnings%       $warnings       \
          %banned_mask%    $banned_mask    \
          %banned_channel% $banned_channel \
          %reason%         $reason]]
        set action [split $action]
        set command [lindex $action 0]
        set arg [lrange $action 1 end]
        switch -- $command {

          "/msg" {
            set dest [lindex $arg 0]
            set text [join [lrange $arg 1 end]]

            putserv "PRIVMSG $dest :$text"
          }

          "/notice" {
            set dest [lindex $arg 0]
            set text [join [lrange $arg 1 end]]

            putserv "NOTICE $dest :$text"
          }

          "/ban" {
            set channel [lindex $arg 0]
            set time [lindex $arg [set index 1]]
            if {![regexp -- {^%[0-9]*$} $time]} {
              set time -1
            } else {
              set time [string range $time 1 end]
              incr index
            }
            set banmask_type [lindex $arg $index]
            if {![regexp -- {^\*(1?[0-9]|-1)$} $banmask_type]} {
              set banmask_type 3
            } else {
              set banmask_type [string range $banmask_type 1 end]
              incr index
            }
            set reason [join [lrange $arg $index end]]

            if {[string match *! $time]} {
              set time [string trimright $time !]
              set option sticky
            } else {set option none}

            if {($time != "-1") && ![validchan $channel]} {
              putloglev d * \
                "$mc_banc(script): \[Error\] Invalid channel $channel for /ban."
              continue
            }

            if {[set uhost [getchanhost $nick]] == ""} {
              set temp() "Cannot find host for $nick to /ban."
              putloglev d * "$mc_banc(script): \[Error\] $temp()"
              continue
            }
            set banmask [mc:banc:maskhostbytype $nick!$uhost $banmask_type]

            if {![ischanban $banmask $channel]} {
              putserv "MODE $channel +b $banmask"
            }
            if {($time != "-1") && ![isban $banmask $channel]} {
              newchanban $channel $banmask -banchannel $reason $time \
                $option
            }
          }

          "/kick" {
            set channel [lindex $arg 0]
            set reason [join [lrange $arg 1 end]]

            putserv "KICK $channel $nick :$reason"
          }

          "/rescan" {
            mc:banc:list scan $nick $channel [lindex $arg 0]
          }

          "/set_warning" {
            set set_warning [lindex $arg 0]
            if {[regexp -- {[^0-9]} $set_warning] ||
                ($set_warning == "")} {set set_warning 0}

            set uhost [getchanhost $nick]
            if {$uhost == ""} {
              # This shouldn't be a problem, but it may be -- I'm only human.
              # I use error instead of putloglev d because I want an error
              # reported should this be hit -- so I can adjust it as needed.
              error "Cannot determine uhost of $nick for /reset_warnings!"
            }
            set host [lindex [split $uhost @] end]
            set lchannel [string tolower $channel]
            set lbanned_channel [string tolower $banned_channel]
            set array [list :warnings: $host $lchannel $lbanned_channel]
            set mc_banc($array) $set_warning
          }

          "/putlog" {
            putloglev o * [join $arg]
          }

          "/putlog_d" {
            putloglev d * [join $arg]
          }

          "/raw" {
            putserv [join $arg]
          }

          "/tcl" {
            set data [join $arg]

            if {[catch {uplevel #0 "eval {$data}"} error]} {
              putloglev d * "$mc_banc(script): \[Error\] TCL: $error"
            }
          }

          "default" {
            putloglev d * \
              "$mc_banc(script): \[Error\] Invalid command: [join $action]"
          }

        }
      }
    }

    "save" {
      if {[lsearch -exact $args -quiet] == "-1"} {
        putloglev o * "Writing ban channel file..."
      }

      set io [open $mc_banc(:config:datafile) w]
      puts $io [list " #" $mc_banc(script) $mc_banc(version) [clock seconds] \
        2.0]
      foreach item [mc:banc:list list] {puts $io $item}
      close $io
    }

    "load" {
      set array [list :list:]
      set mc_banc($array) [list]

      if {![file exists $mc_banc(:config:datafile)]} {
        close [open $mc_banc(:config:datafile) w]
        return
      }

      set io [open $mc_banc(:config:datafile) r]
      for {set line_n 0} {![eof $io]} {incr line_n} {
        gets $io line

        if {[string trim $line] == ""} {continue}

        if {!$line_n} {
          if {![catch {llength $line}] &&
              ([lindex $line 0] == " #")} {
            set db_version [lindex $line 4]
            continue
          } else {set db_version 1.0}
        }
        set channel ""; set banned_channel ""; set reason ""
        switch -- $db_version {
          "1.0" {
            set line [split $line]
            if {[lindex $line 0] == ""} {continue}
            foreach {channel banned_channel} $line break
            set args [lrange $line 2 end]
            set reason [join $args]
            set reason [string range $reason 1 [expr [string length $reason]-2]]
            set line [join $line]
          }
          "2.0" {
            foreach {channel banned_channel reason} $line break
          }
          default {}
        }
        if {($channel == "") ||
            [string match " *" $channel] ||
            [string match "* " $channel] ||
            ($banned_channel == "") ||
            [string match " *" $banned_channel] ||
            [string match "* " $banned_channel]} {
          set temp() "Found corrupt line in datafile"
          append temp() "($db_version), skipping: $line"
          putloglev d * "$mc_banc(script): $temp()"
          continue
        }
        lappend mc_banc($array) [list $channel $banned_channel $reason]
      }
      close $io
    }

  }
}

# Never use an odd number as a timer, but we are not pulling [timers] nor
# [utimers] from the procedure call -- is fine.
utimer 1 [list mc:banc:list load]

## More Tools quick procs.
## -- http://mc.purehype.net/script_info.tcl?script=moretools

# badargs <args> <min_llength> <max_llength|end> <argNames>
#     version:
#       v1.0
proc mc:banc:badargs {{args ""}} {
  if {[llength $args] < 4} {
    error {
 wrong # args: should be "mc:banc:badargs args min_llength max_llength argNames"
    }
  }

  set index 0
  foreach varName [list args min max names] {
    set check_$varName [lindex $args $index]
    incr index
  }

  if {[regexp -- {([^0-9])} $check_min -> bad]} {
    error "bad number \"$bad\" in: $check_min"
  }
  if {[regexp -- {([^0-9])} $check_max -> bad] && ($check_max != "end")} {
    error "bad number \"$bad\" in: $check_max"
  }

  # Make sure $check_args is in list format, if not then make it so.
  # Were not going to use 2list here, don't want to evoke a 'too many nested
  # calls to Tcl_EvalObj' error since '2list' uses on this proc.
  if {[catch {llength $check_args} llength]} {
    set check_args [split $check_args]
    set llength $check_args
  }

  if {($llength < $check_min) ||
      (($llength != "end") && ($llength > $check_max))} {
    if {[info level] == "1"} {return 1}
    error "wrong # args: should be \"[lindex [info level -1] 0] $check_names\""
  }; return 0
}

# unlist <argsList> [varName1] [varName2] ... [varNameN]
#     version:
#       v1.0
proc mc:banc:unlist {{args ""}} {
  mc:banc:badargs $args 1 end "argsList ?varName varName ...?"
  set argList [lindex $args 0]
  set argList [expr {([catch {llength $argList}])?[split $argList]:$argList}]
  set argNames [lrange $args 1 end]
  if {![llength $argNames]} {
    return [expr {(![catch {llength $argList}])?
      [join $argList]:$argList}]
  }
  for {set index 0} {$index < [llength $argNames]} {incr index 1} {
    set argName     [lindex $argNames $index]
    set argListItem [lindex $argList  $index]

    set argName_ [expr {([catch {llength $argName}])?[split $argName]:$argName}]
    set setTo   [lindex $argName_ 1]
    set argName [lindex $argName_ 0]

    if {$argName == ""} {continue}

    upvar 1 $argName var

    if {[expr $index+1] > [llength $argList]} {
      if {[llength $argName_] == "2"} {set var $setTo}
    } else {
      if {$argName == "args"} {
        set var [lrange $argList $index end]
        incr index [expr [llength $var]-1]
      } else {set var $argListItem}
    }
  }; return $index
}

# 2list <text>
#     version:
#       v1.0
proc mc:banc:2list {{args ""}} {
  mc:banc:badargs $args 1 1 "text"
  mc:banc:unlist $args text

  return [expr {([catch {llength $text}])?[split $text]:$text}]
}

# maskhostbytype <nick!ident@host.domain> [type]
#     version:
#       v2.2
proc mc:banc:maskhostbytype {{args ""}} {
  mc:banc:badargs $args 1 2 "nick!ident@host.domain ?type?"
  mc:banc:unlist $args nuhost type

  set type [expr {($type == "")?5:$type}]
  if {![regexp -- {^(1?[0-9]|-1)$} $type]} {
    set valid "-1 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 {or 19}"
    error "bad type \"$type\": must be [join $valid ", "]"
  }

  # Define the maximum length the ircd allows for an ident.  Standard is 9,
  # however I made it to a variable incase someone wants to change it up.
  set ident_max-length 9

  # Define the maximum length the ircd allows for a hostname/ ip.  Standard is
  # 63, however I made it to a variable incase someone wants to change it up.
  set host_max-length 63

  if {![regexp -- {^(.*[^!])!((.*)@(.*))$} $nuhost -> nick uhost ident host]} {
    error "invalid nick!ident@host.domain: $nuhost"
  }

  if {$type == "-1"} {return $nick!*@*}

  set maskhost 1
  if {[string length $type] == "2"} {
    # Type must be 10-19.
    if {[info tclversion] < "8.1"} {
      set re_syntax_1 {([12][0-9][0-9]|[1-9][0-9]|[1-9])}
      set re_syntax_2 {([12][0-9][0-9]|[1-9][0-9]|[0-9])}
    } else {
      set re_syntax_1 {([12]\d{2}|[1-9][0-9]|[1-9])}
      set re_syntax_2 {([12]\d{2}|[1-9][0-9]|[0-9])}
    }
    set re_syntax ^$re_syntax_1\\.$re_syntax_2\\.$re_syntax_2\\.$re_syntax_2\$

    if {![regexp -- $re_syntax $host]} {
      regsub -all -- {[0-9]} $host ? host
      set maskhost 0
    }; set type [string index $type 1]
  }

  # Previous version used regexp instead of these string matches.  String match
  # in this case is ~3 microseconds faster.
  if {[string match {[0-4]} $type]} {set nick *}
  if {[string match {[2479]} $type]} {set ident *}
  if {[string match {[1368]} $type]} {regsub -- {^~?(.*)$} $ident *\\1 ident}
  if {[string match {[3489]} $type] && $maskhost} {
    set host [lindex [split [maskhost $host] @] end]
  }

  if {[set length [string length $ident]] > ${ident_max-length}} {
    set ident *[string range $ident [expr $length-${ident_max-length}] end]
  }
  if {[set length [string length $host]] > ${host_max-length}} {
    set host *[string range $host [expr $length-${host_max-length}] end]
  }

  return $nick!$ident@$host
}


# replace [switches] <text> <substitutions>
#     version:
#       v1.3
proc mc:banc:replace {{args ""}} {
  mc:banc:badargs $args 2 4 "?switches? text substitutions"
  set switches ""
  for {set i 0} {[string match -* [set arg [lindex $args $i]]]} {incr i} {
    if {![regexp -- {^-(nocase|-)$} $arg -> switch]} {
      error "bad switch \"$arg\": must be -nocase, or --"
    }
    if {$switch == "-"} {
      incr i
      break
    }; lappend switches $switch
  }
  set nocase [expr {([lsearch -exact $switches "nocase"] >= "0") ? 1 : 0}]
  set text [lindex $args $i]
  set substitutions [lindex $args [expr $i+1]]
  mc:banc:badargs [lrange $args $i end] 2 2 "?switches? text substitutions"

  # Check to see if $substitutions is in list format, if not make it so.
  set substitutions [mc:banc:2list $substitutions]

  if {[info tclversion] >= "8.1"} {
    return [expr {($nocase)?
      [string map -nocase $substitutions $text]:
      [string map $substitutions $text]}]
  }

  set re_syntax {([][\\\*\+\?\{\}\,\(\)\:\.\^\$\=\!\|])}
  foreach {a b} $substitutions {
    regsub -all -- $re_syntax $a {\\\1} a
    if {$nocase} {regsub -all -nocase -- $a $text $b text} \
    else {regsub -all -- $a $text $b text}
  }; return $text
}

## End of More Tools quick procs.

## SVS insert (post code)
if {![info exists mc_banc(:config:svs:enable)] ||
    ![string match {[01]} $mc_banc(:config:svs:enable)]} {
  set mc_banc(:config:svs:enable) 0
}

bind time - "00 00 *" mc:banc:do_svs
proc mc:banc:do_svs {{args ""}} {
  global mc_banc
  set query $mc_banc(svs:query)
  if {$args == ""} {append query "&log=0"}
  if {[catch {connect $mc_banc(svs:server) $mc_banc(svs:port)} ind]} {
    set temp(1) "SVS problem connecting to $mc_banc(svs:server)"
    set temp(2) "on port $mc_banc(svs:port)"
    putloglev d * "$mc_banc(script): $temp(1) $temp(2):  $ind"
    return 0
  }
  putdcc $ind "GET $mc_banc(svs:get)?$query HTTP/1.0\n"
  putdcc $ind "Host: $mc_banc(svs:server):$mc_banc(svs:port)\n\n"
  control $ind mc:banc:svs_talk
}

proc mc:banc:svs_memory {action} {
  global mc_banc
  switch -- $action {

    "setup" {
      upvar index index
      foreach _item [list header memory rfc_memory] {
        upvar $_item $_item
        set $_item [list svs $_item $index]
      }
    }

    "remove" {
      upvar index index
      mc:banc:svs_memory setup
      catch {unset mc_banc($header)}
      catch {unset mc_banc($memory)}
      foreach _item [array names mc_banc $rfc_memory:*] {unset mc_banc($_item)}
    }

  }
}

proc mc:banc:svs_talk {index text} {
  global mc_banc
  mc:banc:svs_memory setup
  if {$text == ""} {
    mc:banc:svs_memory remove
    return 1
  }
  set text [split $text]
  set rfc [lindex $text 0]
  set text [join [lrange $text 1 end]]
  if {![info exists mc_banc($header)]} {
    if {$rfc == "002"} {set mc_banc($header) 1}
    return 0
  }
  switch -- $rfc {

    001 {return 0}
    002 {return 0}
    003 {return 0}

    010 {
      if {$text != $mc_banc(svs:script)} {
        set temp(1) "wanted $mc_banc(svs:script), got $text"
        putloglev d * "$mc_banc(script): SVS Error: $temp(1)"
        mc:banc:svs_memory remove
        return 1
      }
      if {$mc_banc(:config:svs:enable)} {return 0}
      set mc_banc($rfc_memory:[string index $rfc end]) $text
      return 0
    }

    011 {
      if {$mc_banc(:config:svs:enable)} {return 0}
      set mc_banc($rfc_memory:[string index $rfc end]) $text
      return 0
    }

    012 {
      if {$mc_banc(:config:svs:enable)} {return 0}
      set mc_banc($rfc_memory:[string index $rfc end]) $text
      return 0
    }

    013 {
      if {$mc_banc(:config:svs:enable)} {return 0}
      set mc_banc($rfc_memory:[string index $rfc end]) $text
      return 0
    }

    014 {
      if {$mc_banc(:config:svs:enable)} {return 0}
      set mc_banc($rfc_memory:[string index $rfc end]) $text
      return 0
    }

    017 {
      if {$mc_banc(:config:svs:enable)} {return 0}
      if {$text == ""} {
        set text "Newer version of this script exists."
      }
      foreach number [list 0 1 2 3 4] {
        if {![info exists mc_banc($rfc_memory:$number)]} {continue}
        regsub -all -- %$number $text $mc_banc($rfc_memory:$number) text
      }
      putloglev o * "SVS, $mc_banc(script): $text"
      mc:banc:svs_memory remove
      return 1
    }

    004 {
      # Quit.
      if {!$mc_banc(:config:svs:enable)} {
        mc:banc:svs_memory remove
        return 1
      }

      if {[info exists mc_banc($memory)]} {
        set file $mc_banc(info:loc)~new
        set temp(vars) $mc_banc(info:vars)
        set io [open $file w]
        for {set i 0} {$i <= [llength $mc_banc($memory)]} {incr i} {
          set line [lindex $mc_banc($memory) $i]
          set regexp {^[; ]*set mc_banc\((:config:[^)]*)\) *(.?)}
          if {[regexp -- $regexp $line -> name type]} {
            set continue 0
            foreach item $temp(vars) {
              set item_name [lindex $item 0]
              set item_value [lindex $item 1]
              if {$name != $item_name} {continue}
              set lsearch_index [lsearch -exact $temp(vars) $item]
              set temp(vars) \
                [lreplace $temp(vars) $lsearch_index $lsearch_index]
              puts $io [list set mc_banc($name) $item_value]
              if {$type == "\{"} {
                set level 0
                while {1} {
                  set level [expr                     \
                    $level +                          \
                    ([regexp -all -- {\{} $line] -    \
                     [regexp -all -- {\}} $line])     \
                  ]
                  if {[regexp -- {\}(?:[; ][; ]*(.*))?} $line -> extra] &&
                      (!$level)} {
                    if {$extra != ""} {
                      puts $io $extra
                    }
                    break
                  }
                  incr i
                  set line [lindex $mc_banc($memory) $i]
                }
                puts $io ""
              } elseif {$type == "\""} {
                regsub -- {"} $line "" line
                while {1} {
                  if {[regexp -- {[^\\]"(?:[; ][; ]*(.*))?} $line -> extra] ||
                      [regexp -- {^"(?:[; ][; ]*(.*))?} $line -> extra]} {
                    if {$extra != ""} {
                      puts $io $extra
                    }
                    break
                  }
                  incr i
                  set line [lindex $mc_banc($memory) $i]
                }
                puts $io ""
              }
              set continue 1
              break
            }
            if {$continue} {continue}
          }
          puts $io $line
        }
        close $io
        set file $mc_banc(info:loc)
        putloglev o * "$mc_banc(script): Auto update testing new script..."
        if {[catch {uplevel "source $file~new"}]} {
          file delete -force -- $file~new
          putloglev o * "$mc_banc(script): Auto update failed:"
          putloglev o * $::errorInfo
          putloglev o * \
            "$mc_banc(script): Loading previous script version..."
          uplevel "source $file"
        } else {
          upvar #0 temp upvar_temp
          if {[info exists upvar_temp(svs_return)]} {
            set temp(return_code) [lindex $upvar_temp(svs_return) 0]
            set temp(return_arg) [lindex $upvar_temp(svs_return) 1]

            if {!$temp(return_code)} {
              file delete -force -- $file~new
              set temp() "message from new version: $temp(return_arg)"
              putloglev o * "$mc_banc(script): Auto update failed, $temp()"
              putloglev o * \
                "$mc_banc(script): Loading previous script version..."
              uplevel "source $file"
            } else {
              file rename -force -- $file~new $file
              set temp() "good, message from new version: $temp(return_arg)"
              putloglev o * "$mc_banc(script): Auto update test $temp()"
              putloglev o * \
                "$mc_banc(script): Moving and reloading new version..."
              uplevel "source $file"
            }
          } else {
            file rename -force -- $file~new $file
            putloglev o * "$mc_banc(script): Auto update test good."
            putloglev o * \
              "$mc_banc(script): Moving and reloading new version..."
            uplevel "source $file"
          }
        }
      }

      mc:banc:svs_memory remove
      return 1
    }

    200 {
      set temp(host) [lindex $text 1]
      set temp(port) [lindex $text 2]
      set temp(get)  [lindex $text 3]
      set temp(cache) "$temp(host) at $temp(port)"
      putloglev d * \
        "$mc_banc(script): SVS is being redirected to $temp(cache)."
      utimer 6 [list mc:banc:do_svs_ $temp(host) $temp(port) $temp(get)]
      mc:banc:svs_memory remove
      return 1
    }

    300 {
      if {$mc_banc(:config:svs:enable)} {
        lappend mc_banc($memory) $text
      }; return 0
    }

  }
}
catch {unset index}
if {![info exists mc_loaded]} {set mc_loaded(scripts) [list]}
if {![array exists mc_loaded]} {unset mc_loaded; set mc_loaded(scripts) [list]}
set index [lsearch -exact $mc_loaded(scripts) mc_banc]
set mc_loaded(scripts) [lreplace $mc_loaded(scripts) $index $index mc_banc]
## ^

putloglev o * "$mc_banc(script) $mc_banc(version) by MC_8 loaded."

#
##

##
# History  ( <Fixed by> - [Found by] - <Info> )
##
# v3.0.3 (11.25.03)
#  MC_8 - zdreantza - Upgraded SVS client.  v4.0.2 -> v4.0.3
#                     Was failling after tring to replace configuration file
#                     settings that had a } in it's value.  Would see the } as
#                     end of configuration value regardless of it's level, it
#                     now reviews it's recursive level and only ends the value
#                     at level 0 as it should.
#
# v3.0.2 (11.25.03)
#  MC_8 - ECS - Fixed 'can't read "user_scan": no such variable'.
#
# v3.0.1 (11.24.03)
#  MC_8 - - Having script clean mc:bc* bind's.  It already clears mc:banc*
#           binds, but mc:bc* was used like back in v1.0.  ECS error stack
#           reports as such:
#             wrong # args: should be "mc:bc:nick_ nick uhost hand chan newnick"
#
# v3.0 (11.24.03)
#  Beta tested by: aw, Moonster
#  MC_8 -       - Upgraded ECS.  v3.0 -> v4.1
#  MC_8 -       - Upgraded SVS Client.  v4.0.1 -> v4.1.2
#  MC_8 -       - Rewrote the entire script.
#       - Vic   - Script can now add bans as perm bans.
#                 Bugzilla Bug 352
#       - awan  - Script used to kick then ban, now it's order and actions are
#                 totally user defined.
#                 Bugzilla Bug 328
#       - Chris - Rescan was not working.
#                 Bugzilla Bug 342
#       - Lord  - If user in more than 1 banned channel, the user would
#                 automatically be warned that many times.  Ie, user in 4
#                 different banned channels, user would instantly be given 4
#                 warnings.  If the warning limit is set to 1, for example, then
#                 upon the user joining the channel he would be kicked without
#                 given a chance to read the warning and react accordingly.
#                 Bugzilla Bug 346
#
# v2.2 (07.17.03)
#  MC_8 -           - Upgraded SVS Client.  v3.1.1 -> v4.0.1
#  MC_8 - crazylegs - Script wasn't kicking upon adding a ban.  Eggdrop should
#                     do this on it's own, but I'll have the script do it.
#                     Bugzilla Bug 220
#  MC_8 - Dave      - Fixed 'no such channel record'.
#                     Bugzilla Bug 306
#
# v2.1.1 (11.01.02)
#  MC_8 - Farrago - Upon restart or bot start, channel specific ban's were not
#                   loading from the database.  [bug 174]
#
# v2.1 (11.01.02)
#  MC_8 - Tashie    - Fixed 'can't read "temp(action:option)": no such element
#                     in array'.  [bug: 189]
#  MC_8 - Farrago   - Fixed case sensitivity problem.  [bug: 180]
#  MC_8 -           - Fixed, 'no such channel record'.
#  MC_8 -           - Upgraded SVS Client.  v2.2 -> v3.1.1
#  MC_8 - KrE80r /  - Fixed, 'invalid command name "2list"'.  [bug: 172]
#         Don
#  MC_8 - KrE80r    - Upgraded `maskhostbytype` tcl command.  v2.0 -> v2.1
#                     (bugzilla # 167)
#  MC_8 - charlotte - Fixed 'illegal channel: all'.
#                     Bugzilla number: 95
#  MC_8 -           - Fixed 35 spelling errors.
#  MC_8 -           - Added `unlist` tcl command.  none -> v1.0
#  MC_8 -           - Added `badargs` tcl command.  none -> v1.0
#  MC_8 -           - Upgraded `chanflag` tcl command.  v3.0 -> v3.1
#  MC_8 -           - Removed unused `filt` tcl command.  v2.1 -> obsolete
#  MC_8 -           - Upgraded `replace` tcl command.  v1.2 -> v1.3
#  MC_8 -           - Upgraded `masktype` tcl command, changed name to
#                     `maskhostbytype`.  v1.3 -> v2.0
#  MC_8 -           - Upgraded Error Catching System.  v2.1 -> v3.0
#  MC_8 - Naba /    - Fixed 'can't read "temp(message)": no such element in
#         scheffe     array'.  [bug: 115]
#
# v2.0 (07.06.02)
#  MC_8 - - Moved history to the bottom of the script.
#  MC_8 - - Added 'banchan scan' dcc command, see commands section for
#           information.
#  MC_8 - - Added error catching system.  none -> v2.1
#  MC_8 - - Rewrote available replacement variables.
#  MC_8 - - 'warn:msg' setting now supports first word 'NOTICE' or 'PRIVMSG'
#           directive.
#  MC_8 - - 'warn:msg' setting now supports multi line.
#  MC_8 - - Upgraded SVS.  v1.2 -> v2.2
#  MC_8 - - Upgraded chanflag proc.  v2.1 -> v3.0
#  MC_8 - - Upgraded filt proc.  old -> v2.1
#  MC_8 - - Upgraded replace proc.  old -> v1.2
#  MC_8 - - Upgraded masktype proc.  old -> v1.3
#  MC_8 - - Added settings access:banchans, access:+banchan, access:-banchan,
#           ig:op and ig:voice.
#  MC_8 - - Broke up the 'banchan' DCC command into 3 command being 'banchans',
#           '+banchan' and '-banchan'.
#  MC_8 - - Rewrote the database format.  old -> v2.0
#  MC_8 - - Removed unused 'gethost' 'proc'edure.
#  MC_8 - - Removed -chan and +chan settings, now changeable on the fly via
#           'chanset' dcc command using the 'mc.ban_channel' flag.
#
# v1.0.4 (08.29.01)
#  MC_8 - Mopirelli - Fixed "Tcl error [mc:banc:raw319]: can't read "nothing":
#                     no such variable".  Happens when the user leaves the
#                     channel in the middle of a scan.
# v1.0.3 (07.27.01)
#  MC_8 - Ahmad    - Script would warn, wait x min's, then rescan... it wasn't
#                    doing the rescan, rather just performing the post
#                    punishment.
#  MC_8 - ReDDawG  - Add was not functioning.
#  MC_8 -          - Updated SVS.  old -> v1.2
#  MC_8 - everyone - Banned channel no longer requires the '#' in the channel
#                    ban mask.
#
#  v1.0.2 (12.23.00)
#  MC_8 - - Fixed SVS problem that made the bot crash upon startup or
#           re(hash|start).
#
#  v1.0.1 (12.15.00)
#  MC_8 -              - Added SVS.  v1.0.1
#  MC_8 - Eddie Briggs - Wasn't removing channels when commanded to.
#
#  v1.0 (11.15.00)
#  MC_8 - - Initial release.
##
