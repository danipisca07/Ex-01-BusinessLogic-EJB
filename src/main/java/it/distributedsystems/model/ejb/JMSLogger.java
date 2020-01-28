package it.distributedsystems.model.ejb;

import javax.ejb.ActivationConfigProperty;
import javax.ejb.MessageDriven;
import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.MessageListener;
import javax.jms.TextMessage;

@MessageDriven(activationConfig = {
        @ActivationConfigProperty(propertyName = "destinationType", propertyValue = "javax.jms.Queue"),
        @ActivationConfigProperty(propertyName = "destination", propertyValue = "java:/jms/queue/LoggingQueue") })
public class JMSLogger implements MessageListener {

    @Override
    public void onMessage(Message message) {
        try {
            System.out.println("Logging: " + ((TextMessage) message).getText());
        } catch (JMSException e) {
            e.printStackTrace();
            System.out.println("Errore durante l'interpretazione del messaggio " + message);
        }

    }
}
