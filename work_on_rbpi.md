### Work in jupyter notebooks on raspberry pi

* log in to router with `10.0.0.1`
* find the ip address for the raspberry pi in connected devices
* ssh in: `ssh pi@[ip_address]`
* navigate to directory with Notebooks
* fire up notebook server `jupyter notebook --no-browser --port=8889`
* in another terminal reroute your port to the ssh connection `ssh -N -f -L localhost:8888:localhost:8889 username@your_remote_host_name`
* now in a browser navigate to `localhost:8888`
  * you may need to use the token from the first ssh window for access

*default raspberry pi ssh password: raspberry*
