# nvidia-pytorch-tensorflow-conda-jupyter-ssh
dockerfile for docker image with nvidia-pytorch-tensorflow-conda-jupyter-ssh

### Summary
This is a dockerfile for environment integrating cuda, conda, jupyter, ssh, pytorch and tensorflow. The base image is cuda. The key features include:
- File permissions. Creasing a new user makes the user ids (uid) and group ids (gid) within the container the same as the host. This avoids many issues caused by the file permissions.
- Flexible environment with conda. Using conda, you can easily maintain different versions of Python/packages. Also, feel free to create and register the new environment as jupyter kernel.
- Easy access with ssh and jupyter. The integration of ssh and jupyter allows you to access the environment through ports 22 and 8888 respectively.

### Docker-compose.yaml
To do. 
