package it.distributedsystems.model.dao;

import javax.persistence.*;
import java.io.Serializable;

@Entity
public class OrderVoice implements Serializable {


    protected Purchase purchase;
    protected Product product;
    protected int quantity;
    protected int id;

    public OrderVoice() {
    }

    public OrderVoice(Purchase purchase, Product product, int quantity) {
        this.purchase = purchase;
        this.product = product;
        this.quantity = quantity;
    }


    @Id
    @GeneratedValue
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    @ManyToOne
    public Purchase getPurchase() {
        return purchase;
    }

    public void setPurchase(Purchase purchase) {
        this.purchase = purchase;
    }

    @ManyToOne
    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }


    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}
