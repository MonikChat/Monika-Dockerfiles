# Monika Dockerfile
# Copyright (c) 2018 Clarity. 
FROM ubuntu:16.04
MAINTAINER Capuccino <chinodesuuu@gmail.com>

ENV PORT "8921"

# ansible sucks so I'll compile it via this
ADD compile_container.sh /tmp/
RUN chmod a+x /tmp/compile_container.sh
RUN /tmp/compile_container.sh

ADD passwd_template /tmp/
ADD container_run.sh /tmp/
RUN chmod a+x /tmp/container_run.sh

VOLUME /opt/app/poems
USER 1000
EXPOSE 8921
CMD ["/tmp/container_run.sh"]


# Labels for Kubernetes, OpenShift and Atomic
LABEL io.k8s.description="A PIL-based Poem Generator Service" \
      io.k8s.display-name="Sayori Poem Service" \
      io.openshift.expose-services="8921:http" \
      io.openshift.tags="development, service" \
      io.projectatomic.nulecule.environment.optional="CDN, PORT, PADDING, DEFAULT_BG, DEFAULT_FONT" 
