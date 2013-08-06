package com.wizr.weightlogger.graph;

import com.androidplot.xy.XYSeries;

/**
 * Created by takuya.watabe on 8/6/13.
 */
public class GraphSeries implements XYSeries {
    private DataSource dataSource;
    public GraphSeries(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Override
    public int size() {
        return dataSource.getSize();
    }

    @Override
    public Number getX(int i) {
        return i;
    }

    @Override
    public Number getY(int i) {
        return dataSource.getData(i);
    }

    @Override
    public String getTitle() {
        return "sample";
    }
}
