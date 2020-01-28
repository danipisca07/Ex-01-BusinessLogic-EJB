package it.distributedsystems.model.ejb;

import javax.annotation.Resource;
import javax.interceptor.AroundInvoke;
import javax.interceptor.InvocationContext;
import javax.jms.*;
import javax.naming.Context;
import javax.naming.InitialContext;

public class LoggerInterceptor {

    /*
        Avviare wildfly in versione full da cmd con:
            C:\Standalone\wildfly-18.0.1.Final\bin\standalone.bat -c standalone-full.xml
        Aggiungere prima la queue a wildfly tramite cli:
            jms-queue add --queue-address= jms.queue.LoggingQueue --entries=java:/jms/queue/LoggingQueue,java:/jboss/exported/jms/queue/LoggingQueue
     */

    @Resource(mappedName="java:jboss/DefaultJMSConnectionFactory")    // inject ConnectionFactory
    private ConnectionFactory factory;

    @Resource(mappedName="java:/jms/queue/LoggingQueue")  // inject Queue
    private Queue target;

    @AroundInvoke
    public Object log(InvocationContext ctx) throws Exception{
        String message = "[LOGGING]: " +ctx.getMethod().getName() + "(" +ctx.getMethod().getParameters().toString() + ")";
        Connection connection = factory.createConnection();
        try {
            Session session = connection.createSession(false, Session.AUTO_ACKNOWLEDGE);
            MessageProducer producer = session.createProducer(target);
            producer.send(session.createTextMessage(message));
        }
        finally {
            connection.close();
        }
        return ctx.proceed();
    }
}
