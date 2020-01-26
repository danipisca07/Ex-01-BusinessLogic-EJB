package it.distributedsystems.model.dao;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Set;

@Entity
public class Product implements Serializable {

    private static final long serialVersionUID = 7879128649212648629L;

    protected int id;
    protected int productNumber;
    protected String name;
    protected int price;
    protected Set<OrderVoice> orderVoices;
    protected Producer producer;

    public Product() {}

    public Product(String name) { this.name = name; }

    public Product(String name, int price) { this.name = name; this.price = price; }

    @Id
    @GeneratedValue
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    @Column(unique = true)
    public int getProductNumber() { return productNumber; }

    public void setProductNumber(int productNumber) { this.productNumber = productNumber; }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    @OneToMany(
            cascade = {CascadeType.MERGE,CascadeType.PERSIST,CascadeType.REFRESH},
            fetch = FetchType.LAZY,
            mappedBy = "product"
    )
    public Set<OrderVoice> getOrderVoices() {
        return this.orderVoices;
    }

    public void setOrderVoices(Set<OrderVoice> orderVoices) {
        this.orderVoices = orderVoices;
    }

    @ManyToOne(
            cascade = {CascadeType.PERSIST,CascadeType.REFRESH},
            fetch = FetchType.EAGER
    )
    public Producer getProducer() {
        return producer;
    }

    public void setProducer(Producer producer) {
        this.producer = producer;
    }
}
