sudo catalyst -f stage4-openrc.spec

tar2sqfs root.img < /var/tmp/catalyst/builds/default/stage4-amd64-openrc-\@TIMESTAMP\@.tar.xz
