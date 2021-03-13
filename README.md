# flask-container
Basic files to produce a Flask development container. Only a few things need to be removed or altered to make the container ready for production deployment. The container makes use of the default Apache container as a base.

The basic Flask container comes configured with an extremely BASIC Flask app. Just to demonstrate how to set it up. You will, of course, want to customize this.

The container files, the README and other code here are to provide examples, not to teach Flask. It is assumed you have some knowledge of Flask (or simply need a container or Flask starting point). Please find a Flask tutorial or book for your extended needs.

For Apache config details, see the Official Apache container page on Docker Hub. However, please note, the my-http.conf supplied with this rep DOES include some customizations and sample items, please just don't blow it away until you are sure you don't need it.

Notable features of this container.
- This container is based on the Official Apache container (which is subject to change and may break this example)
- This container, while built to enable an easy entry into a Flask container, is not an official Flask distribution; I am just some guy who needed a Flask container.
- The rep and project contains a number of ease-of-use items that I use to dev all my containers.
  - Optional alternate ENTRYPOINT for the container; the script allows for customization of the container startup sequence.
  - A makefile to facilitate quick builds, deploys, testing, shell access to the container, among other minor things.
  - No warranties. Use at your own risk.
- The exposed ports selected for this example are likely not suitable for production deployments, you will want to change these. They are created this way because I often do not have the default ports available for dev purposes.
  - Port 9090 is the external container port for 80
  - Port 9443 is the external container port for 443
  - Port 5000 is a personal preference for the internal Flask web server used for dev and debugging. If you do not use the internal Flask web server for anything, ignore or remove this. If you intend to use it, then you must define the Flask server to use port 5000 or change the mapping in the docker-compose file to match what you want to use.
  - You might notice the EXPOSE statements in the 'Dockerfile'. In the event you do not know, these are just a documentation feature and have no bearing on actual ports being exposed. I mention it hear because, well, if you change the ports in the docker-compose you, you might want to document those changes in the 'Dockerfile'. I am me, you are you, I can't force you to be orderly, but it's the right thing to do.
- An example mounted volume that is commented out. You must remove the comment mark to enable it. I strongly recommend changing source folder. The mounted volume is disabled by default however.
  - /srv/storage/projects/websites/flask is mapped into the container at, /usr/local/apache2/flask
- Finally, a default, super simple example Flask App is enabled by default. As mentioned in the comment about the example mounted volume, you can uncomment the sections in my-httpd.conf and the docker-compose file to enable the use of the mounted folder for custom flask apps (or just dump copy your code into /usr/local/apache2/htdocs inside the Dockerfile and replace the example)

Ready Container For Production
==============================
Generally, the container can run as-is, however, some changes SHOULD be made.

For starters, if you look in the Dockerfile, it lists a number of items that can be removed because they are mostly for diagnostics during development or customization of the container. The final container does not need these items.

Second, you will want to include SSL certs, customize the Apache conf file add any Flask, Apache or "other" libraries and extensions as you build out the container.

Security matters to, the example base container includes adding some users and groups in the enviroment to facilitate the web server's access to files OUTSIDE the container that may be mounted inside it.

You can eliminate this requirement by include all the code in the container, but more then likely you will want to customize this too, both the user/groups/perms and the mounted volumes.

Lastly, the ports exposed by the docker-compose.yml file will NOT be appropriate for any production install, you will want to alter these to expose the normal HTTP/HTTPS ports, or a select set of ports appropriate to your installation requirements.
