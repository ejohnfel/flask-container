# flask-container
Basic files to produce a Flask development container. Only a few things need to be removed or altered to make the container ready for production deployment. The container makes use of the default Apache container as a base.

The basic Flask container comes configured with an extremely BASIC Flask app. Just to demonstrate how to set it up. You will, of course, want to customize this.

The container files, the README and other code here are to provide examples, not to teach Flask. It is assumed you have some knowledge of Flask (or simply need a container or Flask starting point). Please find a Flask tutorial or book for your extended needs.

Notable features of this container.
1. This container is based on the Official Apache container (which is subject to change and may break this example)
2. This container, while built to enable an easy entry into a Flask container, is not an official Flask distribution; I am just some guy who needed a Flask container.
3. The rep and project contains a number of ease-of-use items that I use to dev all my containers.
	A) Optional alternate ENTRYPOINT for the container; the script allows for customization of the container startup sequence.
	B) A makefile to facilitate quick builds, deploys, testing, shell access to the container, among other minor things
	C) No warranties. Use at your own risk.

Ready Container For Production
==============================
Generally, the container can run as-is, however, some changes SHOULD be made.

For starters, if you look in the Dockerfile, it lists a number of items that can be removed because they are mostly for diagnostics during development or customization of the container. The final container does not need these items.

Second, you will want to include SSL certs, customize the Apache conf file add any Flask, Apache or "other" libraries and extensions as you build out the container.

Security matters to, the example base container includes adding some users and groups in the enviroment to facilitate the web server's access to files OUTSIDE the container that may be mounted inside it.

You can eliminate this requirement by include all the code in the container, but more then likely you will want to customize this too, both the user/groups/perms and the mounted volumes.
