locals {
  output = <<OUTPUT
#### Run these commands
# Check if Traefik is working
curl -H 'Host: traefik.cli-api.fun' ${module.ecs-cluster.alb_dns}

# Check if example task 1 is working (should show the IP of the container)
curl -H 'Host: site-counter-1.cli-api.fun' ${module.ecs-cluster.alb_dns}

# Check if example task 2 is working (should not show the IP of the container)
curl -H 'Host: site-counter-2.cli-api.fun' ${module.ecs-cluster.alb_dns}

# Check if example whoami is working
curl -H 'Host: whoami.cli-api.fun' ${module.ecs-cluster.alb_dns}

#### Example Logs if everything goes fine
🍺  ~$ curl -H 'Host: traefik.cli-api.fun' ecs-traefik-test-app-alb-901515036.ap-southeast-2.elb.amazonaws.com
<a href="/dashboard/">Found</a>.
🍺  ~$

🍺  ~$ curl -H 'Host: site-counter-1.cli-api.fun' ecs-traefik-test-app-alb-901515036.ap-southeast-2.elb.amazonaws.com
aa808ed5b427  -  [172.17.0.3]  -  View Count:  1
🍺  ~$

🍺  ~$ curl -H 'Host: site-counter-2.cli-api.fun' ecs-traefik-test-app-alb-901515036.ap-southeast-2.elb.amazonaws.com
43059b30a193  -  View Count:  1
🍺  ~$
OUTPUT
}

resource "local_file" "ssh_config" {
  content         = local.output
  filename        = "${path.root}/output.txt"
  file_permission = "0644"
}
