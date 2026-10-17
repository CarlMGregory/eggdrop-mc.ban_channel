##
# Ban Channel v2.1.1
#  by MC_8 - Carl M. Gregory <mc8@purehype.net>
#  This script will only run on eggdrop 1.5.5 or greater.
#
#    R.I.P. Mom, To always be remembered; Nancy Marie Gregory.
#
# My Website - http://mc.purehype.net:81/
# Have a bug?  http://mc.purehype.net:81/bugzilla/
##

##
# This script will warn/kick/ban users that are found in banned channels.  You
# can specify what channel masks are to be banned on the fly via dcc console.  A
# channel mask, if you don't know, is a glob type masking of the channel name
# (ie:  *cl* could match #tcl or #clown or any other channel name with a cl in
# it).
##

##
# Commands
##
# DCC:
#   banchans [channel|global|all]
#     This will show you a list of banned channels for the particular channel.
#     If #channel is not specified, it will default to 'all'.
#
#   banchans scan [channel]
#     This will force the bot to scan all users on the specified channel.  If no
#     channel is specified, then it will scan all channels.
#
#   +banchan <channel|global> <#banned_channel> [reason]
#     This will add a new channel ban either globally or to a specific channel.
#     #banned_channel can be masked using the '*' as you wish.
#
#   -banchan <channel|global> <#banned_channel>
#     This will remove a channel ban from the global list or a specific channel.
#     #banned_channel can be masked using the '*' as you wish.
#
#   chanset [channel] <+/->mc.ban_channel
#     This will either enable (+) or disable (-) the script for the specified
#     channel.  By default, channels are disabled untill otherwise set.
#
# If you specify [channel] then the command is channel specific, otherwise
# is global.
#
# <channel> for the add/remove can contain wildcards, incase you want to
# ban certain words in channels names.  Ie. *pre*teen*  *sex*  or whatever.
##

##
# Settings
##
#

# What flagged users are able to utilize the 'banchans' DCC command?  Set this
# to -|- to ensure anyone has access (provided they can DCC chat the bot).
set mc_banc(access:banchans) -|-

# What flagged users are able to utilize the '+banchan' DCC command?  Set this
# to -|- to ensure anyone has access (provided they can DCC chat the bot).
set mc_banc(access:+banchan) m|m

# What flagged users are able to utilize the '-banchan' DCC command?  Set this
# to -|- to ensure anyone has access (provided they can DCC chat the bot).
set mc_banc(access:-banchan) m|m

# What flagged users do you want the script to exempt?  Set this to -|- to
# exempt no one.
set mc_banc(ig:flag) mnb|mn

# [0=no/1=yes] Do you want to exempt opped users?
set mc_banc(ig:op) 1

# [0=no/1=yes] Do you want to exempt voiced users?
set mc_banc(ig:voice) 1

# How long, after the user join's the channel, do you want to wait before
# scanning him/her for banned channels?  This will better 'un lag' the bot by
# scanning only those whom appear to want to stay in the channel.  Set this
# value in seconds.
set mc_banc(flytime) 10

# How often do you want to re-scan the users to see if they have join'd a banned
# channel?  Set this value in minutes, 0 will turn off the re-scan ability --
# therefor users only get scanned upon join'n the channel.
set mc_banc(scan) 30

# What do you want the script to do if someone is found in a banned channel?
#   -2 = Send a warning.
#   -1 = Kick the user from the channel.
#    0 = Ban the user from the channel (server ban only).
#    1 and up is to be considered ban time in minutes, to be added to the bot's
#      internal ban list.  If you pre pend the number with a !, the ban will be
#      sticky.  Also, if you append the number with a @, the ban will be global.
#      Example:  !5@  (sticky global ban that expires in 5 min's)
set mc_banc(pre:pun) -2

# If 'pre:pun' is set to either -2 or -1, you can specify here when you want to
# rescan the user to ensure he/she isn't in any banned channels.  This value
# should represent minutes.
#   Example;  Send them a warning to leave a certain banned channel within 1
#             minute or else.  Then set here to re-scan them in 1 minute.
# You can set this to 0 if you like, this will have the script not rescan upon
# initial warning.
set mc_banc(warn:time) 1

# Specify your message here.  This will be used for the warning (if 'pre:pun' is
# set to -2), for the kick message (if 'pre:pun' is set to -1) or the ban
# comment (if 'pre:pun' is set to 1 or above).  The first word in this should
# represent either 'PRIVMSG' or 'NOTICE'.  If this is to be used for sending a
# warning, then that's the method in witch it's sent.  Otherwise the first word
# is just ignored.  Even if this is to be used for something other than a
# warning, you must still supply a first word witch will be ignored (just leave
# it set to 'PRIVMSG' or something, doesn't matter -- just going to be ignored).
#   Replacment variables, variables that are going to be replaced with there
#   proper value are listed below:
#     %banned_mask    - The banned channel mask the user triggered when being
#                       scanned.
#     %banned_channel - The banned channel that was found with the banned
#                       channel mask (the exact channel name of the channel in
#                       question).
#     %channel        - The channel that doesn't want this 'banned channel'
#                       associated with (simply put, the channel the bot is
#                       monitoring, associated with that user).
#     %reason         - The reason for the banned channel mask, specified when
#                       the ban channel mask is added via dcc command.
# This can support multi lines, specify each new line with a new line.  Also,
# don't forget the 'PRIVMSG' or 'NOTICE' for each new line.  Multi lines are
# only used for warning messages.  If ban command or kick message, only the
# first line is used (from the second word to the end of the first line, of
# course).
set mc_banc(warn:msg) {
  PRIVMSG You have 1 minute to leave %banned_channel.
  PRIVMSG Failure to do so will result in you being banned in %channel.
}

# Users only get 1 warning, if they use up that warning then what do you want
# this script to do?
#   -1 = Kick the user from the channel.
#    0 = Ban the user from the channel (server ban only).
#    1 and up is to be considered ban time in minutes, to be added to the bot's
#      internal ban list.  If you pre pend the number with a !, the ban will be
#      sticky.  Also, if you append the number with a @, the ban will be global.
#      Example:  !5@  (sticky global ban that expires in 5 min's)
set mc_banc(post:pun) 5

# What kick message (if 'post:pun' is set to -1) or ban comment (if 'post:pun'
# is set to 1 or above) do you want for users that have exceeded there warnings?
#   Replacment variables, variables that are going to be replaced with there
#   proper value are listed below:
#     %banned_mask    - The banned channel mask the user triggered when being
#                       scanned.
#     %banned_channel - The banned channel that was found with the banned
#                       channel mask (the exact channel name of the channel in
#                       question).
#     %channel        - The channel that doesn't want this 'banned channel'
#                       associated with (simply put, the channel the bot is
#                       monitoring, associated with that user).
#     %reason         - The reason for the banned channel mask, specified when
#                       the ban channel mask is added via dcc command.
# Unlike 'warn:msg', witch uses the same replacement variables, you do not need
# to specify 'PRIVMSG' nor 'NOTICE' as the first word -- nor does this support
# multi lines.  For, this is surely not being used to send messages, only kick
# message or ban comments.
set mc_banc(post:msg) "You were warned to leave %banned_channel.  %reason"

# How do you want to bans that supplied by this script to be masked?
#       Valid types are:
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
#       You can also specify a type of 10-19 which corresponds to types 0-9,
#       using this sub rule;  If host.domain is a(n)-
#         name - Instead of using a * wildcard to replace portions of the
#                host.domain, it replaces the numbers in the host.domain with a
#                '?' (question mark) wildcard.
#         ip   - It will mask as normal, with no '?' (question mark)
#                replacements as does hostname.
set mc_banc(banmask) 3


# Where do you want the data this script uses to be stored at?  It is relative
# to the directory in witch you start the bot from.
set mc_banc(datafile) "scripts/.badc.data"


## SVS Client (Script Version Service) v3.1.1 ##
# Once a day, the SVS Client will connect to MC_8's SVS Server to determine if
# there is a newer version of this script available.  This will only notify
# users of the new version via a note.  It's up to the owner of the bot to
# download, adjust settings then install the script.

# If a newer version is found, whom do you want to notify?  The notification is
# sent via a note.  Seperate each user with a space, or set this to "" to
# disable SVS notification.  For those whom know TCL; do not put this in list
# format, keep it in string format.
set mc_banc(svs:notify) "MC_8"

# Would you like to restrict the concept of a new version to stable releases
# only?
#   0 = No, inform of both stable and beta release versions.
#   1 = Yes, inform of only stable release versions.
set mc_banc(svs:mode) 0


##


##
# Edit no further, tcl coding below.
##

#Script:mc_banc

set mc_banc(script)      "Ban Channel"
set mc_banc(version)     "v2.1.1"
set mc_banc(svs:script)  "banchan"
set mc_banc(svs:version) "002001001000"
set mc_banc(svs:server)  "mc.svs.purehype.net"
set mc_banc(svs:port)    "81"
set mc_banc(svs:get)     "/index.tcl"
set mc_banc(svs:query)   \
  "svs=$mc_banc(svs:script)&version=$mc_banc(svs:version)"

catch {unset temp}
if {![info exists numversion] || ($numversion < "1050500")} {
  set temp(tag) "$mc_banc(script) $mc_banc(version)"
  putlog "$temp(tag) by MC_8 will only work on eggdrop 1.5.5 or greater."
  putlog "$temp(tag)  will not work with eggdrop $version."
  putlog "$temp(tag)  not loaded."
  return 1
}

setudef flag mc.ban_channel

# Error system, v3.0
proc mc:banc:error {command error arg} {
  global mc_banc version lastbind errorInfo
  putlog "Error in script $mc_banc(script) $mc_banc(version)."
  putlog "    Error System: v3.0"
  putlog "       Last Bind: [expr {[info exists lastbind]?$lastbind:"-NULL-"}]"
  putlog "         Command: $command"
  putlog "       Arguments: $arg"
  putlog "       Error Msg: $error"
  putlog "    Egg. Version: [expr {[info exists version]?$version:"-NULL-"}]"
  putlog "     TCL Version: [info tclversion]"
  putlog "  TCL Patchlevel: [info patchlevel]"
  putlog "*** Please submit this bug so MC_8 can fix it.  Visit"
  putlog "*** http://mc.purehype.net:81/bugzilla/ to properly report the bug."
  putlog \
    "*** Please include ALL info. in the bug report, including the next(s)."
  error $errorInfo
}

proc mc:banc:errchk {command arg} {
  if {![catch {eval $command $arg} return]} {return $return}
  mc:banc:error $command $return $arg
  return 0
}
# ^

# banchans [channel|global|all]
# banchans scan [channel]
bind dcc - banchans mc:banc:dcc:banchans
proc mc:banc:dcc:banchans {hand idx arg} {
  return [mc:banc:errchk mc:banc:dcc:banchans_ [list $hand $idx $arg]]
}
proc mc:banc:dcc:banchans_ {hand idx arg} {
  global mc_banc
  set chan [lindex [split $arg] 0]
  if {$chan == "scan"} {
    set scan 1
    set chan [lindex [split $arg] 1]
  } else {
    set scan 0
  }
  if {$chan == ""} {set chan "all"}

  # Access restriction
  if {$mc_banc(access:banchans) == "-|-"} {
    set temp(has_access) 1
  } else {
    if {![validchan $chan]} {
      set temp(flag) [lindex [split $mc_banc(access:banchans) |] 0]
      set temp(has_access) [matchattr $hand $temp(flag)]
    } else {
      set temp(has_access) [matchattr $hand $mc_banc(access:banchans) $chan]
    }
  }
  if {!$temp(has_access)} {
    putloglev c * "#$hand# (denied) banchans $chan"
    putdcc $idx "Insufficent access, denied."
    return 0
  }
  # ^

  if {$scan} {
    if {$chan == "all"} {
      set channels [channels]
    } elseif {![validchan $chan]} {
      putdcc $idx "Invalid channel: $chan"
      return 0
    } else {
      if {![mc:banc:chanflag $chan mc.ban_channel]} {
        putdcc $idx "The script is disabled for that channel."
        return 0
      }
      if {![mc:banc:list has_bans $chan]} {
        set temp(1) "There are no bans setup for that channel"
        putdcc $idx "$temp(1), no need to waste bandwidth by doing a scan."
        return 0
      }
      set channels [list $chan]
    }
    set temp(chanlist) ""
    foreach channel $channels {
      if {![mc:banc:chanflag $channel mc.ban_channel] ||
          ![mc:banc:list has_bans $channel]} {continue}
      lappend temp(chanlist) $channel
      foreach temp(nick) [chanlist $channel] {
        if {[isbotnick $temp(nick)]} {continue}
        mc:banc:join $temp(nick) [getchanhost $temp(nick) $channel] \
          [nick2hand $temp(nick) $channel] $channel
      }
    }
    set temp(llength) [llength $temp(chanlist)]
    if {!$temp(llength)} {
      putdcc $idx "No available channels to channel."
      return 0
    } elseif {[llength $temp(chanlist)] == "1"} {
      set s ""
    } else {
      set s s
    }
    putdcc $idx "Scanning channel$s: [join $temp(chanlist) ", "]"
    return 1
  }

  putdcc $idx "Banned channel listing:  (! = script disabled for channel)"
  set temp(list) ""
  set temp(length) 6
  foreach temp(entry) [mc:banc:list list $chan] {
    lappend temp(list) $temp(entry)
    set temp(cur_len) [string length [lindex $temp(entry) 0]]
    if {$temp(cur_len) > $temp(length)} {
      set temp(length) $temp(cur_len)
    }
  }
  set temp(list) [lsort -dictionary -index 1 $temp(list)]
  set temp(list) [lsort -dictionary -index 0 $temp(list)]
  foreach temp(entry) $temp(list) {
    set chan [lindex $temp(entry) 0]
    set ban_chan [lindex $temp(entry) 1]
    set reason [lindex $temp(entry) 2]
    if {[validchan $chan] && ![mc:banc:chanflag $chan mc.ban_channel]} {
      set temp(!) "!"
    } else {
      set temp(!) " "
    }
    putdcc $idx [format "%s   %-$temp(length)s: %s  (Reason: %s)" $temp(!) \
      $chan $ban_chan $reason]
  }
  return 1
}

#   +banchan <#channel|global> <#banned_channel> [reason]
bind dcc - +banchan mc:banc:dcc:+banchan
proc mc:banc:dcc:+banchan {hand idx arg} {
  return [mc:banc:errchk mc:banc:dcc:+banchan_ [list $hand $idx $arg]]
}
proc mc:banc:dcc:+banchan_ {hand idx arg} {
  global mc_banc
  set arg [split $arg]
  set chan [lindex $arg 0]
  set ban_chan [lindex $arg 1]
  set reason [join [lrange $arg 2 end]]
  set temp(syntax) {+banchan <channel|'global'> <banned_channel> [reason]}

  if {$ban_chan == ""} {
    putdcc $idx "Usage: $temp(syntax)"
    return 0
  }

  # Access restriction
  if {$mc_banc(access:+banchan) == "-|-"} {
    set temp(has_access) 1
  } else {
    if {![validchan $chan]} {
      set temp(flag) [lindex [split $mc_banc(access:+banchan) |] 0]
      set temp(has_access) [matchattr $hand $temp(flag)]
    } else {
      set temp(has_access) [matchattr $hand $mc_banc(access:+banchan) $chan]
    }
  }
  if {!$temp(has_access)} {
    putloglev c * "#$hand# (denied) +banchan $chan $ban_chan $reason"
    putdcc $idx "Insufficent access, denied."
    return 0
  }
  # ^

  switch -- [mc:banc:list add $chan $ban_chan $reason] {
    1 {
      putdcc $idx "Invalid channel: $chan"
      return 0
    }
    2 {
      putdcc $idx "Usage: $temp(syntax)"
      return 0
    }
    3 {
      putdcc $idx "Ban channel entry already exists."
      return 0
    }
  }
  if {[validchan $chan] && ![mc:banc:chanflag $chan mc.ban_channel]} {
    putdcc $idx "$mc_banc(script) isn't enabled for $chan, adding anyhow."
  }
  putdcc $idx "Added $ban_chan ($reason) to $chan's ban channel list."
  return 1
}

#   -banchan <#channel|global> <#banned_channel>
bind dcc - -banchan mc:banc:dcc:-banchan
proc mc:banc:dcc:-banchan {hand idx arg} {
  return [mc:banc:errchk mc:banc:dcc:-banchan_ [list $hand $idx $arg]]
}
proc mc:banc:dcc:-banchan_ {hand idx arg} {
  global mc_banc
  set arg [split $arg]
  set chan [lindex $arg 0]
  set ban_chan [lindex $arg 1]
  set temp(syntax) {-banchan <channel|'global'> <banned_channel>}

  if {$ban_chan == ""} {
    putdcc $idx "Usage: $temp(syntax)"
    return 0
  }

  # Access restriction
  if {$mc_banc(access:-banchan) == "-|-"} {
    set temp(has_access) 1
  } else {
    if {![validchan $chan]} {
      set temp(flag) [lindex [split $mc_banc(access:-banchan) |] 0]
      set temp(has_access) [matchattr $hand $temp(flag)]
    } else {
      set temp(has_access) [matchattr $hand $mc_banc(access:-banchan) $chan]
    }
  }
  if {!$temp(has_access)} {
    putloglev c * "#$hand# (denied) -banchan $chan $ban_chan"
    putdcc $idx "Insufficent access, denied."
    return 0
  }
  # ^

  if {![mc:banc:list remove $chan $ban_chan]} {
    putdcc $idx "No such ban channel entry."
    return 0
  }
  if {[validchan $chan] && ![mc:banc:chanflag $chan mc.ban_channel]} {
    putdcc $idx "$mc_banc(script) isn't enabled for $chan, removing anyhow."
  }
  putdcc $idx "Removed $ban_chan from $chan's ban channel list."
  return 1
}

bind join - * mc:banc:join
proc mc:banc:join {nick uhost hand chan} {
  return [mc:banc:errchk mc:banc:join_ [list $nick $uhost $hand $chan]]
}
proc mc:banc:join_ {nick uhost hand chan} {
  global mc_banc
  if {[isbotnick $nick]} {
    set mc_banc(:info:joined:[string tolower $chan]) [clock seconds]
    return 0
  }
  if {![mc:banc:chanflag $chan mc.ban_channel] ||
      ![mc:banc:list has_bans $chan] ||
      (($mc_banc(ig:flag) != "-|-") &&
       [matchattr $hand $mc_banc(ig:flag) $chan])} {
    return 0
  }
  if {!$mc_banc(flytime)} {
    mc:banc:schedule_scan $nick $chan 0
  } else {
    mc:banc:schedule_scan $nick $chan $mc_banc(flytime)
  }
  return 1
}

bind raw - 315 mc:banc:raw:315
proc mc:banc:raw:315 {from key arg} {
  return [mc:banc:errchk mc:banc:raw:315_ [list $from $key $arg]]
}
proc mc:banc:raw:315_ {from key arg} {
  #315> telnet #abc123 :End of /WHO list.
  global mc_banc
  set chan [lindex [split $arg] 1]
  set array ":info:joined:[string tolower $chan]"
  if {![info exists mc_banc($array)] ||
      ([clock seconds] > [expr $mc_banc($array)+10]) ||
      ![mc:banc:chanflag $chan mc.ban_channel] ||
      ![mc:banc:list has_bans $chan]} {return 0}
  foreach temp(nick) [chanlist $chan] {
    if {[isbotnick $temp(nick)]} {continue}
    mc:banc:join $temp(nick) [getchanhost $temp(nick) $chan] \
                                             [nick2hand $temp(nick) $chan] $chan
  }
  return 0
}

bind raw - 319 mc:banc:raw:319
proc mc:banc:raw:319 {from key arg} {
  return [mc:banc:errchk mc:banc:raw:319_ [list $from $key $arg]]
}
proc mc:banc:raw:319_ {from key arg} {
  #319> telnet MC_8 :#mp34free #gamerzwarez #ftpwarez #abc123 @#tcl #warez4free
  #319> telnet Eggdrop :-@#tcl
  global mc_banc
  set arg [split $arg]
  set nick [lindex $arg 1]
  set hand [nick2hand $nick]

  # Setting up whois_channels in list format, channel names without status.
  set temp(whois_channels) [join [lrange $arg 2 end]]
  regexp -- {^:?(.*)$} $temp(whois_channels) dummy temp(whois_channels)
  set temp(buffer) ""
  foreach temp(item) [split $temp(whois_channels)] {
    lappend temp(buffer) [string trimleft $temp(item) -+@%]
  }
  set temp(whois_channels) $temp(buffer)
  foreach chan [channels] {
    if {![onchan $nick $chan] ||
        ![mc:banc:chanflag $chan mc.ban_channel] ||
        ![mc:banc:list has_bans $chan] ||
        ![botisop $chan] ||
        (($mc_banc(ig:flag) != "-|-") &&
         [matchattr $hand $mc_banc(ig:flag) $chan]) ||
        ($mc_banc(ig:op) && [isop $nick $chan]) ||
        ($mc_banc(ig:voice) && [isvoice $nick $chan])} {continue}
    foreach ban "[mc:banc:list list global] [mc:banc:list list $chan]" {
      set banned_mask [lindex $ban 1]
      set reason [lindex $ban 2]
      set temp(a) [string tolower $temp(whois_channels)]
      set temp(b) [string tolower $banned_mask]
      set index [lsearch -glob $temp(a) $temp(b)]
      if {$index == "-1"} {continue}
      set banned_chan [lindex $temp(whois_channels) $index]
      mc:banc:punish $nick $chan $banned_mask $banned_chan $reason
    }
  }
}

bind nick - * mc:bc:nick
proc mc:bc:nick {nick uhost hand chan newnick} {
  return [mc:banc:errchk mc:bc:nick_ [list $nick $uhost $hand $chan $newnick]]
}
proc mc:bc:nick_ {nick uhost hand chan newnick} {
  if {![isbotnick $newnick]} {
    mc:banc:join $newnick $uhost $hand $chan
  }
}

# Save memory to datafile upon userfile save.
bind evnt - save mc:banc:evnt:save
proc mc:banc:evnt:save {type} {
  return [mc:banc:errchk mc:banc:evnt:save_ [list $type]]
}
proc mc:banc:evnt:save_ {type} {
  mc:banc:list save
}

# Return: 0- Sent WHOIS
#         1- Didn't sent WHOIS, invalid channel.
#         2- Didn't send WHOIS, user not on channel.
#         3- Didn't send WHOIS, already awaiting whois reply.
#         4- Didn't send WHOIS, no bans setup for that channel-- so no need to
#            scan (bandwidth saver).
#         5- Didn't send WHOIS, bot isn't opped-- wouldn't be able to punish if
#            on banned channel anyhow (bandwidth saver).
proc mc:banc:scan {nick chan} {
  return [mc:banc:errchk mc:banc:scan_ [list $nick $chan]]
}
proc mc:banc:scan_ {nick chan} {
  global mc_banc
  if {![validchan $chan]} {return 1}
  if {![onchan $nick $chan]} {return 2}
  if {![mc:banc:list has_bans $chan]} {return 4}
  if {![botisop $chan]} {return 5}
  set array ":info:waiting_scan:$nick"
  set temp(command) [list catch [list unset mc_banc($array)]]
  if {[lsearch -glob [utimers] "* [list $temp(command)] *"] == "-1"} {
    utimer 30 $temp(command)
  }
  if {[info exists mc_banc($array)]} {return 3}
  set mc_banc($array) 1
  putserv "WHOIS $nick"
  return 0
}

# Schedule a scan, -force says you want to reset time to assigned 'seconds'
# regardless if it's already in timer queue.
proc mc:banc:schedule_scan {nick chan seconds {force ""}} {
  return [mc:banc:errchk mc:banc:schedule_scan_ \
    [list $nick $chan $seconds $force]]
}
proc mc:banc:schedule_scan_ {nick chan seconds force} {
  global mc_banc
  set temp(command) [list mc:banc:scan $nick $chan]
  set temp(utimers) [utimers]
  set temp(lsearch) [lsearch -glob $temp(utimers) "* [list $temp(command)] *"]
  if {$temp(lsearch) >= "0"} {
    if {$force == "-force"} {
      killutimer [lindex [lindex $temp(utimers) $temp(lsearch)] 2]
    } else {
      return 0
    }
  }
  if {$seconds} {
    utimer $seconds [list mc:banc:scan $nick $chan]
  } else {
    mc:banc:scan $nick $chan
  }
}

proc mc:banc:punish {nick chan banned_mask banned_chan reason} {
  return [mc:banc:errchk mc:banc:punish_ [list $nick $chan $banned_mask \
    $banned_chan $reason]]
}
proc mc:banc:punish_ {nick chan banned_mask banned_chan reason} {
  global mc_banc botnet-nick
  set uhost [getchanhost $nick $chan]
  set host [lindex [split $uhost @] end]
  set user_bmask [mc:banc:maskhostbytype $nick!$uhost $mc_banc(banmask)]
  set array ":info:punish:$host"
  if {![info exists mc_banc($array)]} {
    set mc_banc($array) 0
  }
  if {!$mc_banc($array)} {
    # Warning stage.
    set action [list "\[Warning Level\]"]

    # Get message in list format.
    set message ""
    foreach temp(item) [split $mc_banc(warn:msg) \n] {
      set temp(item) [string trimleft $temp(item) "   "]
      set temp(a) [lindex [split $temp(item)] 0]
      set temp(b) [join [lrange [split $temp(item)] 1 end]]
      if {([string trim $temp(a) " "] == "") ||
          ([string trim $temp(b) " "] == "")} {continue}
      lappend message [list $temp(a) $temp(b)]
    }
    # ^

    if {![string match !* $mc_banc(pre:pun)]} {
      set temp(option) none
      set temp(action:option) ""
    } else {
      set temp(option) sticky
      set temp(action:option) "sticky, "
    }
    set temp(global) [string match *@ $mc_banc(pre:pun)]
    set time [string trim $mc_banc(pre:pun) !@]

    switch -- $time {
      -2 {
        foreach temp(line) $message {
          set temp(method) [lindex $temp(line) 0]
          set temp(message) [lindex $temp(line) 1]
          set temp(umethod) [string toupper $temp(method)]
          if {![regexp -- {^(NOTICE|PRIVMSG)$} $temp(umethod)]} {
            continue
          }
          set temp(message) [mc:banc:replace $temp(message) [list \
            %banned_mask    $banned_mask \
            %banned_channel $banned_chan \
            %channel        $chan \
            %reason         $reason]]
          puthelp "$temp(umethod) $nick :$temp(message)"
        }
        if {[llength $message]} {
          lappend action "sent warning message via $temp(method)"
        }
      }
      -1 {
        set temp(message) [lindex [lindex $message 0] 1]
        if {$temp(message) == ""} {
          set temp(message) $mc_banc(script)
        } else {
          set temp(message) [mc:banc:replace $temp(message) [list \
            %banned_mask    $banned_mask \
            %banned_channel $banned_chan \
            %channel        $chan \
            %reason         $reason]]
        }
        putkick $chan $nick $temp(message)
        lappend action "kicked"
      }
      0 {
        pushmode $chan +b $user_bmask
        lappend action "banned (server ban)"
      }
      default {
        if {$time > 0} {
          set temp(action) ""
          set temp(duration) [duration [expr $time*60]]
          set temp(message) [lindex [lindex $message 0] 1]
          if {$temp(message) == ""} {
            set temp(message) $mc_banc(script)
          } else {
            set temp(message) [mc:banc:replace $temp(message) [list \
              %banned_mask    $banned_mask \
              %banned_channel $banned_chan \
              %channel        $chan \
              %reason         $reason]]
          }
          if {$temp(global)} {
            newban $user_bmask ${botnet-nick} $temp(message) $time $temp(option)
            append temp(action) "global, $temp(action:option) $temp(duration)"
          } else {
            newchanban $chan $user_bmask ${botnet-nick} $temp(message) $time \
              $temp(option)
            append temp(action) \
              "$chan ban, $temp(action:option) $temp(duration)"
          }
          lappend action "Banned (internal banlist, $temp(action))"
        }
      }
    }
    if {[regexp -- {^-[12]$} $mc_banc(pre:pun)]} {
      mc:banc:schedule_scan $nick $chan [expr $mc_banc(warn:time)*60] -force
    }
  } else {
    # Post warning stage.
    set action [list "\[Post Warning Level\]"]

    if {![string match !* $mc_banc(post:pun)]} {
      set temp(option) none
      set temp(action:option) ""
    } else {
      set temp(option) sticky
      set temp(action:option) "sticky, "
    }
    set temp(global) [string match *@ $mc_banc(post:pun)]
    set time [string trim $mc_banc(post:pun) !@]

    if {$mc_banc(post:msg) == ""} {
      set temp(message) $mc_banc(script)
    } else {
      set temp(message) [mc:banc:replace $mc_banc(post:msg) [list \
        %banned_mask    $banned_mask \
        %banned_channel $banned_chan \
        %channel        $chan \
        %reason         $reason]]
    }

    switch -- $time {
      -1 {
        putkick $chan $nick $temp(message)
        lappend action "kicked"
      }
      0 {
        pushmode $chan +b $user_bmask
        lappend action "banned (server ban)"
      }
      default {
        if {$time > 0} {
          set temp(action) ""
          set temp(duration) [duration [expr $time*60]]
          if {$temp(global)} {
            newban $user_bmask ${botnet-nick} $temp(message) $time $temp(option)
            append temp(action) "global, $temp(action:option) $temp(duration)"
          } else {
            newchanban $chan $user_bmask ${botnet-nick} $temp(message) $time \
              $temp(option)
            append temp(action) \
              "$chan ban, $temp(action:option) $temp(duration)"
          }
          lappend action "Banned (internal banlist, $temp(action))"
        }
      }
    }
    if {$mc_banc(post:pun) == "-1"} {
      mc:banc:schedule_scan $nick $chan [expr $mc_banc(warn:time)*60] -force
    }
  }
  incr mc_banc($array)
  set temp(1) "$nick at $chan found on banned channel"
  set temp(2) "$banned_chan ($banned_mask), action taken:"
  putlog "$mc_banc(script): $temp(1) $temp(2) [join $action ", "]"
  return 1
}

# mc:banc:list load
# mc:banc:list save [-quiet]
# mc:banc:list list [#channel|global|all]
#   Default= 'all'
# mc:banc:list add <#channel> <ban_mask> <reason>
#   0- Added.
#   1- Invalid channel.
#   2- ban_mask is "", invalid.
#   3- Entry already exists.
# mc:banc:list remove <#channel> <ban_mask>
#   0- No such entry.
#   1- Removed.
# mc:banc:list has_bans <#channel>
#   0- No.
#   1- Yes.
proc mc:banc:list {{args ""}} {
  return [mc:banc:errchk mc:banc:list_ $args]
}
proc mc:banc:list_ {args} {
  global mc_banc
  set array_name "!banchan"
  switch -- [lindex $args 0] {
    load {
      set mc_banc($array_name) ""
      if {![file exists $mc_banc(datafile)]} {
        close [open $mc_banc(datafile) w]
      } else {
        set io [open $mc_banc(datafile) r]
        for {set temp(line_n) 0} {![eof $io]} {incr temp(line_n)} {
          gets $io temp(line)
          if {[string trim $temp(line)] == ""} {continue}
          if {!$temp(line_n)} {
            if {![catch {llength $temp(line)}] &&
                ([lindex $temp(line) 0] == " #")} {
              set temp(db_version) [lindex $temp(line) 4]
              continue
            } else {set temp(db_version) 1.0}
          }
          switch -- $temp(db_version) {
            1.0 {
              set temp(line) [split $temp(line)]
              if {[lindex $temp(line) 0] == ""} {continue}
              set temp(line:0) [lindex $temp(line) 0]
              set temp(line:1) [lindex $temp(line) 1]
              set temp(line:2) [join [lrange $temp(line) 2 end]]
              set temp(line:2_expr) [expr [string length $temp(line:2)]-2]
              set temp(line:2) [string range $temp(line:2) 1 $temp(line:2_expr)]
            }
            2.0 {
              set temp(line:0) [lindex $temp(line) 0]
              set temp(line:1) [lindex $temp(line) 1]
              set temp(line:2) [lindex $temp(line) 2]
            }
            default {
              set temp(line:0) ""
              set temp(line:1) ""
              set temp(line:2) ""
            }
          }
          mc:banc:list add $temp(line:0) $temp(line:1) $temp(line:2)
        }
        close $io
      }
    }
    save {
      if {[lindex $args 1] != "-quiet"} {
        putlog "Writing ban channel file..."
      }
      set io [open $mc_banc(datafile) w]
      # Script, Version, UnixTime, DB_Version
      puts $io [list " #" $mc_banc(script) $mc_banc(version) [clock seconds] \
        2.0]
      foreach item [mc:banc:list list] {
        puts $io $item
      }
      close $io
    }
    list {
      # chan(for), chan(mask-bad), reason
      if {[set chan [string tolower [lindex $args 1]]] == ""} {
        set chan "all"
      }
      set temp(return) ""
      foreach temp(entry) $mc_banc($array_name) {
        if {($chan == "all") || ([lindex $temp(entry) 0] == $chan)} {
          lappend temp(return) $temp(entry)
        }
      }
      return $temp(return)
    }
    add {
      set temp(arg:1) [string tolower [lindex $args 1]]
      set temp(arg:2) [string tolower [lindex $args 2]]
      set temp(arg:3) [lindex $args 3]
      if {![validchan $temp(arg:1)] && ($temp(arg:1) != "global")} {
        return 1
      }
      if {$temp(arg:2) == ""} {
        return 2
      }
      set temp(1) [list $temp(arg:1) $temp(arg:2)]
      set temp(ls) [lsearch -glob $mc_banc($array_name) "$temp(1) *"]
      if {$temp(ls) != "-1"} {
        return 3
      }
      lappend mc_banc($array_name) [list $temp(arg:1) $temp(arg:2) $temp(arg:3)]
      return 0
    }
    remove {
      set temp(arg:1) [string tolower [lindex $args 1]]
      set temp(arg:2) [string tolower [lindex $args 2]]
      set temp(1) [list $temp(arg:1) $temp(arg:2)]
      set temp(ls) [lsearch -glob $mc_banc($array_name) "$temp(1) *"]
      if {$temp(ls) == "-1"} {
        return 0
      }
      set mc_banc($array_name) \
                            [lreplace $mc_banc($array_name) $temp(ls) $temp(ls)]
      return 1
    }
    has_bans {
      set chan [string tolower [lindex $args 1]]
      foreach temp(entry) $mc_banc($array_name) {
        set temp(entry:chan) [lindex $temp(entry) 0]
        if {($chan == $temp(entry:chan)) || ($temp(entry:chan) == "global")} {
          return 1
        }
      }
      return 0
    }
  }
}

## More Tools quick procs.
## -- http://mc.purehype.net:81/script_info.tcl?script=moretools

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
#       v2.1
proc mc:banc:maskhostbytype {{args ""}} {
  mc:banc:badargs $args 1 2 "nick!ident@host.domain ?type?"
  mc:banc:unlist $args nuhost type


  set type [expr {($type == "")?5:$type}]
  if {![regexp -- {^1?[0-9]$} $type]} {
    set valid "0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 {or 19}"
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


# chanflag <channel> <flag>
#     version:
#       v3.1
proc mc:banc:chanflag {{args ""}} {
  mc:banc:badargs $args 2 2 "channel flag"
  mc:banc:unlist $args channel flag

  if {![validchan $channel]} {error "no such channel record"}

  # Try the 'channel' commands' 'get' option first, it's faster since it is
  # written in C by the eggdrop development team.
  if {![catch {channel get $channel $flag} output]} {return $output}

  set temp(chaninfo) [string tolower [channel info $channel]]
  if {[lsearch -exact $temp(chaninfo) +[string tolower $flag]] >= "0"} {
    return 1
  }
  return 0
}

## End of More Tools quick procs.


# Load datafile to memory.
utimer 1 [list mc:banc:list load]


## SVS v3.1.1
set mc_banc(svs:client_version) "v3.1.1"
if {![info exists mc_banc(svs:mode)] ||
    ![regexp -- {^(1|0)$} $mc_banc(svs:mode)]} {
  set mc_banc(svs:mode) 0
}
if {![info exists mc_banc(svs:notify)]} {
  if {![info exists owner]} {set owner ""}
  set mc_banc(svs:notify) $owner
}

bind time - "00 00 *" mc:banc:do_svs
proc mc:banc:do_svs {{args ""}} {
  global mc_banc
  mc:banc:do_svs_ $mc_banc(svs:server) $mc_banc(svs:port) $mc_banc(svs:get)
}

proc mc:banc:do_svs_ {svs_server svs_port svs_get} {
  global mc_banc tcl_platform
  if {[catch {
          socket -async $svs_server $svs_port
             } sid]} {
    putloglev d * "$mc_banc(script): SVS socket error: $sid"
    return 1
  }

  # This block of code is to get a standard User-Agent line of information, as
  # proposed in http://www.mozilla.org/build/revised-user-agent-strings.html
  foreach array_name [list platform os osVersion machine] {
    set temp($array_name) [lindex [array get tcl_platform $array_name] 1]
  }
  switch -- $temp(platform) {
    windows {
      switch -- $temp(os) {
        Windows {set temp(2) Win$temp(osVersion)}
        "Windows 95" {
          if {$temp(osVersion) < "4.10"} {
            set temp(2) Win95
          } else {
            set temp(2) Win98
          }
        }
        "Windows 98" {set temp(2) Win98}
        "Windows NT" {
          if {$temp(osVersion) >= "5.0"} {
            set temp(2) "Windows NT $temp(osVersion)"
          } else {
            set temp(2) WinNT$temp(osVersion)
          }
        }
        default {
          set temp(2) "$temp(os) $temp(osVersion)"
        }
      }
    }
    unix {
      set temp(2) "unix $temp(machine)"
    }
    macintosh {
      set temp(2) $temp(machine)
    }
    default {
      set temp(2) "$temp(os) $temp(osVersion) $temp(machine)"
    }
  }
  set temp(user_agent) "Mozilla/5.001 ($temp(platform); U; $temp(2); en) "
  append temp(user_agent) "Gecko/25250101 $mc_banc(svs:script)/"
  append temp(user_agent) "$mc_banc(svs:version) SVS_Client/"
  append temp(user_agent) "$mc_banc(svs:client_version)"
  # ^

  fconfigure $sid -blocking 0 -buffering line
  set tout [after 60000 "mc:banc:svs_talk $sid timeout $svs_server $svs_port"]
  fileevent $sid readable "mc:banc:svs_talk $sid $tout"
  puts $sid "GET $svs_get?$mc_banc(svs:query) HTTP/1.0\
           \nHost: $svs_server:$svs_port\
           \nUser-Agent: $temp(user_agent)\n"
  flush $sid
}

proc mc:banc:svs_talk {sid tout {svs_server ""} {svs_port ""}} {
  global mc_banc
  set array [list svs temp $sid]
  if {$tout == "timeout"} {
    set temp(1) "$svs_server:$svs_port"
    putloglev d * \
      "$mc_banc(script): SVS Warning: Timed out connecting to $temp(1)."
    catch {unset mc_banc($array)}
    close $sid
    return 0
  }
  if {[eof $sid]} {
    catch {unset mc_banc($array)}
    close $sid
    return 1
  }
  gets $sid get
  after cancel $tout
  if {![info exist mc_banc($array)]} {
    if {$get == ""} {set mc_banc($array) 1}
    return -1
  }
  if {($get == "") || [catch {llength $get}]} {
    return -2
  }
  switch -- [lindex $get 0] {
    200 {
      set temp(host) [lindex $get 1]
      set temp(port) [lindex $get 2]
      set temp(get) [lindex $get 3]
      set temp(cache) "$temp(host) at $temp(port)"
      putloglev d * "$mc_banc(script): SVS is being redirected to $temp(cache)."
      mc:banc:do_svs_ $temp(host) $temp(port) $temp(get)
      close $sid
      return 200
    }
    003 {
      set temp(reply) [lrange $get 1 end]
      for {set number 0} {$number <= 5} {incr number} {
        set temp(reply:$number) [lindex $temp(reply) $number]
      }
      if {$temp(reply:0) != $mc_banc(svs:script)} {
        set temp(1) "wanted $mc_banc(svs:script), got $temp(reply:0)"
        putloglev d * "$mc_banc(script): SVS Error: $temp(1)"
        unset mc_banc($array)
        close $sid
        return -3
      }
      if {$mc_banc(svs:mode)} {
        set temp(svs:version) [string range $mc_banc(svs:version) 0 8]999
      } else {
        set temp(svs:version) [string range $mc_banc(svs:version) 0 11]
      }
      if {$temp(reply:1) > $temp(svs:version)} {
        set temp(note) $temp(reply:5)
        regsub -all -- %0 $temp(note) $temp(reply:0) temp(note)
        regsub -all -- %1 $temp(note) $temp(reply:1) temp(note)
        regsub -all -- %2 $temp(note) $temp(reply:2) temp(note)
        regsub -all -- %3 $temp(note) $temp(reply:3) temp(note)
        regsub -all -- %4 $temp(note) $temp(reply:4) temp(note)
        regsub -all -- %version $temp(note) $mc_banc(version) temp(note)
        foreach temp(to) [split $mc_banc(svs:notify) ",; "] {
          if {[string trim $temp(to)] == ""} {continue}
          regsub -- %nick $temp(note) $temp(to) temp(note2)
          set temp(lunotes) [notes $temp(to) -[notes $temp(to)]]]
          if {[string match *$temp(note2)* $temp(lunotes)]} {
            set temp(found_note) 0
            foreach temp(unote) $temp(lunotes) {
              if {$temp(note2) == [lindex $temp(unote) 2]} {
                set temp(found_note) 1
                break
              }
            }
            if {$temp(found_note)} {continue}
          }
          set temp(error) "sending note to $temp(to) -> "
          switch -- [sendnote SVS $temp(to) $temp(note2)] {
            0 {
              if {![validuser $temp(to)]} {
                append temp(error) "invalid user"
              } else {append temp(error) "unknown error"}
              putloglev d * \
                "$mc_banc(script): SVS sendnote error: $temp(error)"
            }
            3 {
              append temp(error) "notebox too full"
              putloglev d * \
                "$mc_banc(script): SVS sendnote error: $temp(error)"
            }
          }
        }
      }
      unset mc_banc($array)
      close $sid
      return 2
    }
  }
}
## ^


putlog "$mc_banc(script) $mc_banc(version) by MC_8 loaded."

##
# History  ( <Fixed by> - [Found by] - <Info> )
##
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
#  MC_8 - - Inital release.
##