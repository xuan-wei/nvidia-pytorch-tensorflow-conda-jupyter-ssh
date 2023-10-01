# nvidia-pytorch-tensorflow-conda-jupyter-ssh
This is a Dockerfile for an environment that integrates CUDA, Conda, Jupyter, SSH, PyTorch, TensorFlow (and Code Server).  This dockerfile is mainly designed for creating different environment for different users when you want to share a server with other users.

### Summary
The key features include:
- **Flexible environment with Conda**: Using Conda, you can easily maintain different versions of Python and packages. You can also create and register new environments as Jupyter kernels. For example, when you want to register a new env (python 3.10 + tensorflow 2.11), use the following code 
```bash
conda create -n "name_of_env" python=3.10 ipykernel # build new env
conda activate "name_of_env" # switch to the new env
python -m ipykernel install --user --name "name_of_env" --display-name "name shown in Jupyter"
```

- **Easy access with SSH and Jupyter**: SSH and Jupyter are integrated into the environment, allowing you to access it through ports 22 and 8888, respectively.

- **File permissions**: Creating a new user ensures that the user IDs (UID) and group IDs (GID) within the container are the same as those on the host. This avoids many file permission issues.

- **Computing resource sharing and limiting**: Docker ensures that a single user does not occupy the computing resources exclusively. Additionally, you can easily set resource limitations when setting up the Docker containers.

- **Separation and persistency of file systems**: Each user in Docker has its own file system. By setting up the Docker containers, you can mount key folders into the host machines, enabling persistency.


### How to compile a docker image from Dockerfile
Suppose you want to compile from `Dockerfile.combined_pt_tf`. Navigate to the directory and use the following command:
``` 
sudo docker build -t <image_name> -f Dockerfile.combined_pt_tf --build-arg PASSWORD=<password> .
```
Replace `<image_name>` and `<password>` with your desired values. Also, feel free to change the variables (USER, UID, GID, TZ) and version of packages (python, TensorFlow, PyTorch, etc.) in the dockerfile.

### Dockerfile.combined vs. Dockerfile.separate
These two versions exist because for some 

### Docker-compose.yaml for starting a docker container
``` docker
version: "3"

services:
  pt-tf:
    container_name: <to_replace> # name
    image: <image_name>
    hostname: Ubuntu
    restart: always
    # privileged: true # this can avoid nvidia-smi error (Failed to initialize NVML: Unknown Error) after calling systemctl daemon-reload. However, this also gives all capabilities to the container. A better way is to diable privileged and mount devices manually (see below).
    init: true # Run an init inside the container that forwards signals and reaps processes. see https://docs.docker.com/compose/compose-file/compose-file-v3/
    pid: "host" # share pid with host to allow container to use nvidia-smi to show the processes ocupying GPUs 
    volumes:
      - ./data:/home/sjtu/workspace:rw
      # - /data/<to_replace>:/home/sjtu/data:rw # uncomment it when you need to mount more folders
    ports:
      - "<to_replace>:8888" # port for jupyter
      - "<to_replace>:22" # port for ssh
      - "<to_replace>:1000" # reserved some ports
      - "<to_replace>:1001" # reserved some ports
      - "<to_replace>:1002" # reserved some ports
    devices:
      - /dev/nvidia0:/dev/nvidia0
      #- /dev/nvidia1:/dev/nvidia1 # if you got multiple gpus
      - /dev/nvidiactl:/dev/nvidiactl
      - /dev/nvidia-caps:/dev/nvidia-caps
      - /dev/nvidia-modeset:/dev/nvidia-modeset
      - /dev/nvidia-uvm:/dev/nvidia-uvm
      - /dev/nvidia-uvm-tools:/dev/nvidia-uvm-tools
    deploy:
      resources:
        reservations: # whether use gpu or not
          devices:
            - capabilities: ["gpu"]
              device_ids: ["0"]
        # limits: # set cpu  and memory limits
          # cpus: 48
          # memory: 40960M

```

After starting the container, you can access the container via ssh or Jupyter with ports 22 or 8888 respectively.