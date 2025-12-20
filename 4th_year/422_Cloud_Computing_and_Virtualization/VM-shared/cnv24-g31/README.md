# SpecialVFX@Cloud - G31

## Architecture:
1. `raytracer` - the Ray Tracing workload
2. `imageproc` - the BlurImage and EnhanceImage workloads
3. `webserver` - the web server exposing the functionality of the workloads
4. `javassist` - the monitoring and analysis plug-in
5. `webserver.autoscaler` - the auto-scaling logic
6. `loadbalancer` - the load balancing logic
7. `dynamodb` - the storage for metrics and other data (stored via the javassist tool)

## Configuration Selections:

### Auto Scaling Group Parameters:
  - Minimum instances: 1
  - Maximum instances: 3
  - Scaling policies:
    - Cooldown period: 1 minute
    - CPU load > 70% for 1 minutes <!-- **and** VolumeQueueLength > 3 --> &rarr; add 1 instance
    - CPU load < 30% for 1 minutes &rarr; remove 1 instance
    - Unhealthy instances &rarr; replace instance

### ELB Load Balancer Parameters:
  - Distributor factor: instruction count (`javassist.tools.InstructionCounter`)

### Health Check Parameters:
  - Frequency: 60 seconds
  - Common between ELB and Auto Scaling Group

## Metrics Collection
The metric extracted by the `InstructionCounter` tool is being stored in a file on the computing nodes, by redirecting the terminal's standard output.
### The metric is:
  - Executed intruction count
  - Executed block count
  - CPU load