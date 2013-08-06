package com.wizr.weightlogger.fragment;

import android.graphics.Color;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.androidplot.xy.LineAndPointFormatter;
import com.androidplot.xy.PointLabelFormatter;
import com.androidplot.xy.XYPlot;
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

        plot.addSeries(series, new LineAndPointFormatter(
                Color.rgb(0, 0, 0), null, Color.rgb(0, 80, 0), new PointLabelFormatter()
        ));

        LineAndPointFormatter f1 = new LineAndPointFormatter(
                Color.rgb(0, 0, 200), null, Color.rgb(0, 0, 80), new PointLabelFormatter()
        );
        f1.getFillPaint().setAlpha(220);

        return rootView;
    }
}
