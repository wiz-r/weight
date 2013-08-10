package com.wizr.weightlogger.fragment;

import android.graphics.Color;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.androidplot.xy.BoundaryMode;
import com.androidplot.xy.LineAndPointFormatter;
import com.androidplot.xy.PointLabelFormatter;
import com.androidplot.xy.XYPlot;
import com.androidplot.xy.XYStepMode;
import com.wizr.weightlogger.R;
import com.wizr.weightlogger.graph.DataSource;
import com.wizr.weightlogger.graph.GraphSeries;

import java.text.DecimalFormat;

/**
 * Created by takuya.watabe on 8/6/13.
 */
public class GraphFragment extends Fragment {
    private XYPlot plot;
    private DataSource dataSource;

    public GraphFragment() {
        dataSource = new DataSource(); // temp
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_graph, container, false);

        plot = (XYPlot)rootView.findViewById(R.id.dynamicPlot);
        plot.getGraphWidget().setDomainValueFormat(new DecimalFormat("0"));

        GraphSeries series = new GraphSeries(dataSource);

        LineAndPointFormatter f1 = new LineAndPointFormatter(
                Color.rgb(0, 0, 200), Color.rgb(80, 0, 0), 0, null
        );
        f1.getFillPaint().setAlpha(0);
        f1.getVertexPaint().setStrokeWidth(10);

        plot.addSeries(series, f1);

        /*
        plot.setDomainStepMode(XYStepMode.SUBDIVIDE);
        plot.setDomainStepValue(series.size());

        plot.setTicksPerDomainLabel(5);
        plot.setTicksPerRangeLabel(3);
        */

        plot.setRangeBoundaries(30, 100, BoundaryMode.FIXED);

        return rootView;
    }
}
