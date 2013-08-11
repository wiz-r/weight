package com.wizr.weightlogger.graph;

import com.wizr.weightlogger.data.WeightData;

import java.util.HashMap;

/**
 * Created by takuya.watabe on 8/6/13.
 */
public class DataSource {
    private WeightData[] data = {
            new WeightData(1375887600L, 75.1F),
            new WeightData(1375974000L, 75.0F),
            new WeightData(1376060400L, 74.8F),
            new WeightData(1376146800L, 74.2F),
    }; // tmp
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
