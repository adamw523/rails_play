# making remote directory and rsyncing devserver
# ssh <devbox> mkdir -p rails_devserver
# rsync -avz -e ssh devserver/ <devbox>:rails_devserver

# running devserver on remote
# ssh <devbox> "bash -s" < startdev.sh

cd rails_devserver
docker build -t adamw523/rails_devserver .
docker stop rails_devserver
docker rm rails_devserver
docker run -p 3000 -p 22 -h rails_devserver --name rails_devserver -d --volumes-from devshare_host adamw523/rails_devserver
