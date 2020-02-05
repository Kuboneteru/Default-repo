#!/usr/bin/expect

set RemoteHost [lindex $argv 0]
set Member [lindex $argv 1]
set Prompt "\[#>\]"

set timeout 5

proc abort {} {
  send_user "Failed Expect Scripts\n"
  exit 1
}

#connect SW
spawn /usr/bin/ssh admin@${RemoteHost}
expect {
    "(yes/no)?" {
        send "yes\n"
        exp_continue
    }
    "password:" {
        send -- "${PW}\n"
    }
}

expect "${Prompt}"

send "request system reboot member ${Member} at now\n"
expect {
  -timeout 30
  timeout abort
  "\(no\)" { }
}

send "yes\n"
expect {
  -timeout 100
  timeout abort
  "Rebooting" { }
}

sleep 30
exit 0
