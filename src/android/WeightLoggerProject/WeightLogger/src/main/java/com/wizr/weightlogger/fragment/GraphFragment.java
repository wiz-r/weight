package com.wizr.weightlogger.fragment;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.androidplot.xy.XYPlot;
import com.wizr.weightlogger.R;

/**
 * Created by takuya.watabe on 8/6/13.
 */
public class GraphFragment extends Fragment {
    private XYPlot plot;

    public GraphFragment() {
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_graph, container, false);
        plot = (XYPlot)rootView.findViewById(R.id.dynamicPlot);
        return rootView;
    }
}
