## Traefik ECS Demo

## What are we up to?
We will use [Traefik](https://containo.us/traefik/) to proxy incoming requests based on `Host` headers to the ECS Services.

Don't judge me on the code quality :). I've purposely not used `https`, `301` redirection and other fancy stuff as this demo is to just to show the capability of traefik to proxy requests in an AWS ECS environment.

## Why not just ALB?
[ALB](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html) can definitely do the job but needs more efforts (either manual or custom some automation). To use a common ALB (and save costs), for every service one needs create a target group, ALB rule, and refer those in the service definition.
Remember you need to manage the lifecycle of the service i.e. create and delete corresponding resources when you create or delete a service.

![](files/images/without_traefik.png)


## Why Traefik?
Traefik takes the overhead of managing multiple target groups and rules for each and every service in ALB, and we just need one ALB and target group. Why do the work when Traefik is here :)
Traefik adds and deletes are virtual hosts for each service automagically.

Traefik does the redirection (to the upstream services) based on a `Host` header. In my example, I am running it in `DAEMON` mode i.e. one per host.

![](files/images/with_traefik.png)

*NOTE*: I am deliberately using Traefik v1 and not v2 as there is no ECS provider for v2 yet. This should not discourage anyone as v1 is still being updated (or bug fixed). For all other purpose, please use v2. You can thank me later :)

## Pre-Requsities
* Basic knowlegde on AWS and EC2 Container Service (ECS)
* Install these tools. These have been tested on Mac and Linux. I try to stay away from Windows :)
    - Terraform 0.12.X
    - Docker
    - AWS CLI
* Export AWS Region and Credentials (i.e. `AWS_PROFILE` variable)
    ```bash
    🍺  ~$ export AWS_PROFILE=traefik-ecs-demo
    🍺  ~$ export AWS_DEFAULT_REGION=ap-southeast-2
    ```

## Let's Do It !
* Create a Key Pair and a docker image (on top of official Traefik image) and store it in ECR (of the same AWS Account)
    ```bash
    🍺  ~$ make pre-reqs
    ```
    Note: The fifth line in the script (`./files/docker/traefik/docker-entrypoint.sh`),  I've replaced two variables `$CLUSTER_HOST` and `$DOMAIN`. These are the ones which I have in the ECS task definition of Traefik. It just helps to avoid hard coding stuff in the docker repository.

* Initialize Terraform
    ```bash
    🍺  ~$ make tf-init
    ```

* (Optional) See what resources we are going to create
    ```bash
    🍺  ~$ make tf-plan
    ```

* Create ECS Cluster
    ```bash
    🍺  ~$ make tf-apply
    ```

    The above command will create below AWS Resources
    * VPC with public and private subnets
    * Public ALB
    * ECS cluster
    * three ECS Tasks
        * Traefik
        * Sample Task 1
        * Sample Task 2

        Traefik task uses the docker image which had built and pushed to ECR, and the sample tasks uses [site-counter](https://registry.hub.docker.com/repository/docker/vikas027/site-counter)) docker image. The above command will create a file `output.txt` in the current directory with some commands to test your setup.


### Check if everything is working as expected
* Check the commands shown in `output.txt`
    ```bash
    🍺  ~$ cat output.txt
    ```

* Traefik Test: Services and Dashboard (through curl)
    ```bash
    🍺  ~$ curl -H 'Host: traefik.cli-api.fun' ecs-traefik-test-app-alb-901515036.ap-southeast-2.elb.amazonaws.com
    <a href="/dashboard/">Found</a>.
    🍺  ~$

    🍺  ~$ curl -H 'Host: site-counter-1.cli-api.fun' ecs-traefik-test-app-alb-901515036.ap-southeast-2.elb.amazonaws.com
    aa808ed5b427  -  [172.17.0.3]  -  View Count:  1
    🍺  ~$

    🍺  ~$ curl -H 'Host: site-counter-2.cli-api.fun' ecs-traefik-test-app-alb-901515036.ap-southeast-2.elb.amazonaws.com
    43059b30a193  -  View Count:  1
    🍺  ~$
    ```

* Create a CNAME (or an Route53 Alias) which points to the DNS of ALB
For example, it could be `traefik.cli-api.fun`

* Alternatively, just use a firefox extension like [Modify Header Value](https://mybrowseraddon.com/modify-header-value.html) or [ModHeader](https://addons.mozilla.org/en-US/firefox/addon/modheader-firefox/) to fake the host header in the browser.
    You should have something like this with extention [Modify Header Value](https://mybrowseraddon.com/modify-header-value.html).
        ![](files/gifs/traefik_dashboard.gif)

## Nuke Everything
- ECS cluster and resources using Terraform
    ```bash
    🍺  ~$ make nuke
    ```
- This will delete all AWS resources we have created so far including ECR Repository and Key Pair

## References
* https://docs.traefik.io/v1.7/configuration/backends/ecs/
* https://github.com/vikas027/site-counter

## Alternatives
There are a few alternatives but I have not tried these out.
* AWS [Route53](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/service-discovery.html)
* Hashicorp Consul

## Questions/Issues:
If you a suggestion to simplify this demo further for newbies, feel free to raise a PR or create an issue.

## Finally
Traefik is awesome, I absolutely love it. Traefik is my goto reverse proxy on Kubernetes, Docker, or even when I need static files. Traefik v2 (a complete overhaul) is awesome too, and works beautifully on Kubernetes. Try it out :)
