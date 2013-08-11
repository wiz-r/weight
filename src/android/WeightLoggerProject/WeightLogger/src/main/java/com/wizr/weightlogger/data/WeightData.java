package com.wizr.weightlogger.data;

/**
 * Created by takuya on 8/10/13.
 */
public class WeightData {
    private Long timestamp;
    private Float weight;

    public WeightData(Long timestamp, Float weight) {
        this.timestamp = timestamp;
        this.weight = weight;
    }

    public Long getTimestamp() {
        return timestamp;
    }

    public Float getWeight() {
        return weight;
    }

    public void setTimestamp(Long timestamp) {
        this.timestamp = timestamp;
    }

    public void setWeight(Float weight) {
        this.weight = weight;
    }
}
