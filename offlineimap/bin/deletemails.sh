echo "Deleting emails older than 100 days."
archivemail -d 100 --delete --pwfile="~/pixelabuse.pwd" imaps://\"m@mafro.net\"@mail.gandi.net/INBOX
archivemail -d 100 --delete --pwfile="~/pixelabuse.pwd" imaps://\"m@mafro.net\"@mail.gandi.net/oii
#archivemail -d 100 --delete --pwfile="~/pixelabuse.pwd" imaps://\"m@mafro.net\"@mail.gandi.net/Sent

