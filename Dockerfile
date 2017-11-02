FROM jboss/keycloak-postgres:3.3.0.Final

RUN mkdir -p /opt/jboss/keycloak/modules/system/layers/base/org/jgroups/kubernetes/main
ADD kube_ping/jars/* /opt/jboss/keycloak/modules/system/layers/base/org/jgroups/kubernetes/main/
ADD kube_ping/kube-ping-module.xml /opt/jboss/keycloak/modules/system/layers/base/org/jgroups/kubernetes/main/module.xml
ADD kube_ping/module.xml /opt/jboss/keycloak/modules/system/layers/base/org/jgroups/main/module.xml

RUN rm -rf /opt/jboss/keycloak/standalone/configuration/standalone_xml_history
RUN rm -rf /opt/jboss/keycloak/standalone_ha/configuration/standalone_xml_history

ADD cli /opt/jboss/keycloak/cli
RUN cd /opt/jboss/keycloak && bin/jboss-cli.sh --file=cli/standalone-ha-configuration.cli && rm -rf /opt/jboss/keycloak/standalone/configuration/standalone_xml_history

EXPOSE 8080 8443 8888

CMD ["-b", "0.0.0.0", "--server-config", "standalone-ha.xml"]
