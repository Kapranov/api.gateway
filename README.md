# GatewayApi

**TODO: Add description**

 1. clean up Kafka log dirs every time when it starts app - `rm -fr /opt/kafka/logs/*`
 2. change dir to app - `cd api.gateway`
 3. start up - `./zookeeper.sh`
 4. start up - `./kafka.sh`
 5. create topic `MyTopic` - `sudo -u kafka /opt/kafka/bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic MyTopic`
 6. create topic `kaffe-test` - `sudo -u kafka /opt/kafka/bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic kaffe-test`
 7. subscription to topic `MyTopic` - `sudo -u kafka /opt/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic MyTopic --from-beginning`
 8. subscription to topic `kaffe-test` - `sudo -u kafka /opt/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic kaffe-test --from-beginning`
 9. start up an application - `.run.sh`
10. in any browsers - `http://159.224.174.183/graphiql`
    you can change addresss in file - `config/config.exs:20,22`

#### Documentations

1. [Demo source Code with mocks](https://github.com/Kapranov/api.gateway)
2. [MessageGateway-2023](https://docs.google.com/document/d/12V9lx624V2ceomt-D2tZep-rn364SQDR)
3. [MessageGateway-2019](https://e-health-ua.atlassian.net/wiki/spaces/smsEH/pages/17311662534/2019.+MessageGateway)
4. [MessagesGateway.API](https://bitbucket.org/ehealth_gov_ua/messagesgateway.api/src/staging/)
5. [MVP (draft) - розробка](https://e-health-ua.atlassian.net/wiki/spaces/smsEH/pages/17537695885/MVP+draft+-)
6. [Models with Seeders](https://docs.google.com/spreadsheets/d/10Nk1V1sC78qdyJH5ran2lNFoy8aoq0BGel_HCQSlWaQ/edit?pli=1&gid=1216018441#gid=1216018441)
7. [Technicals](https://docs.google.com/document/d/1Z3dj86m0NLJhF5V5NGideV5v_QPwmyT6/edit)
8. [Task-67](https://e-health-ua.atlassian.net/browse/SMSEH-67)
9. [Task-87](https://e-health-ua.atlassian.net/browse/SMSEH-87)
10. [Task-91](https://e-health-ua.atlassian.net/browse/SMSEH-91)
11. [Task-92](https://e-health-ua.atlassian.net/browse/SMSEH-92)
12. [Projects](https://bitbucket.org/ehealth_gov_ua/workspace/projects/EP)
13. [RFP](https://drive.google.com/drive/folders/1h1yQ8jd8wwpkkAVsHLLv5KFu-etjrdoo)
14. [2023-01-06](https://e-health-ua.atlassian.net/wiki/spaces/smsEH/pages/17311891457/2023+01+26+eHealth)
15. [Notification-Service](https://docs.google.com/document/d/1XvcrLli9VLtYWS5G-Dnu4j2Ul72bP9cd/edit)

### 5 September 2023 by Oleg G.Kapranov
