package com.wizr.weightlogger.data;

import java.util.Comparator;

/**
 * Created by takuya on 8/11/13.
 */
public class WeightDataComparator implements Comparator<WeightData> {
    @Override
    public int compare(WeightData weightData, WeightData weightData2) {
        return (int)(weightData.getTimestamp() - weightData2.getTimestamp());
    }
}
