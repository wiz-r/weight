package com.wizr.weightlogger.fragment;

import android.graphics.Color;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.androidplot.ui.SizeLayoutType;
import com.androidplot.ui.SizeMetrics;
import com.androidplot.xy.BoundaryMode;
import com.androidplot.xy.LineAndPointFormatter;
import com.androidplot.xy.PointLabelFormatter;
import com.androidplot.xy.XYPlot;
import com.androidplot.xy.XYStepMode;
import com.wizr.weightlogger.R;
import com.wizr.weightlogger.data.WeightDataCollection;
import com.wizr.weightlogger.graph.DataSource;
import com.wizr.weightlogger.graph.GraphSeries;

import java.text.DecimalFormat;
import java.text.FieldPosition;
import java.text.Format;
import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created by takuya.watabe on 8/6/13.
 */
public class GraphFragment extends Fragment {
    private static final float margin = 0.2f;
    private static final long oneDay = 60 * 60 * 24;
    private XYPlot plot;
    private DataSource dataSource;

    public GraphFragment() {
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_graph, container, false);

        WeightDataCollection collection = WeightDataCollection.getCollection(rootView.getContext());
        dataSource = new DataSource(collection);

        plot = (XYPlot)rootView.findViewById(R.id.dynamicPlot);
        plot.getGraphWidget().setDomainValueFormat(new DecimalFormat("0"));

        GraphSeries series = new GraphSeries(dataSource);

        LineAndPointFormatter f1 = new LineAndPointFormatter(
                Color.rgb(0, 0, 200), Color.rgb(80, 0, 0), 0, null
        );
        f1.getFillPaint().setAlpha(0);
        f1.getVertexPaint().setStrokeWidth(10);

        plot.addSeries(series, f1);

        // X Axis
        plot.setDomainValueFormat(new Format() {
            private SimpleDateFormat dateFormat = new SimpleDateFormat("MM/dd");
            @Override
            public StringBuffer format(Object o, StringBuffer stringBuffer, FieldPosition fieldPosition) {
                long timestamp = ((Number) o).longValue() * 1000;
                Date date = new Date(timestamp);
                return dateFormat.format(date, stringBuffer, fieldPosition);
            }

            @Override
            public Object parseObject(String s, ParsePosition parsePosition) {
                return null;
            }
        });

        plot.setDomainStep(XYStepMode.INCREMENT_BY_VAL, oneDay);

        long latest = dataSource.getMaxTimestamp();
        long maxX = latest + oneDay;
        long minX = maxX - 7 * oneDay;
        plot.setDomainBoundaries(minX, maxX, BoundaryMode.FIXED);

        // Y Axis
        float maxY = dataSource.getMaxWeight() + margin;
        float minY = dataSource.getMinWeight() - margin;
        plot.setRangeBoundaries(minY, maxY, BoundaryMode.FIXED);

        return rootView;
    }
}
