package com.wizr.weightlogger.graph;

import com.wizr.weightlogger.data.WeightData;
import com.wizr.weightlogger.data.WeightDataCollection;

import java.util.HashMap;

/**
 * Created by takuya.watabe on 8/6/13.
 */
public class DataSource {
    private WeightData[] data;

    public DataSource(WeightDataCollection collection) {
        data = collection.getArray();
    }

    public int getSize() {
        return data.length;
    }

    public WeightData getData(int index) {
        return data[index];
    }

    public float getMaxWeight() {
        if (data.length == 0) {
            return 0F;
        }

        float max = data[0].getWeight();
        for (int i = 1; i < data.length; i++) {
            if (data[i].getWeight() > max) {
                max = data[i].getWeight();
            }
        }

        return max;
    }

    public float getMinWeight() {
        if (data.length == 0) {
            return 0F;
        }

        float min = data[0].getWeight();
        for (int i = 1; i < data.length; i++) {
            if (data[i].getWeight() < min) {
                min = data[i].getWeight();
            }
        }

        return min;
    }

    public long getMaxTimestamp() {
        if (data.length == 0) {
            return 0L;
        }

        long max = data[0].getTimestamp();
        for (int i = 1; i < data.length; i++) {
            if (data[i].getTimestamp() > max) {
                max = data[i].getTimestamp();
            }
        }

        return max;
    }
}
