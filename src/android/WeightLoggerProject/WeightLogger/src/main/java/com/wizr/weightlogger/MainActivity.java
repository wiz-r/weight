package com.wizr.weightlogger;

import java.util.Locale;

import android.app.ActionBar;
import android.app.FragmentTransaction;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.Menu;
import android.view.MenuItem;
import net.hockeyapp.android.CrashManager;
import net.hockeyapp.android.UpdateManager;

import com.flurry.android.FlurryAgent;
import com.growthpush.GrowthPush;
import com.growthpush.model.Environment;
import com.wizr.weightlogger.fragment.GraphFragment;
import com.wizr.weightlogger.fragment.InputDialogFragment;
import com.wizr.weightlogger.fragment.MainFragment;

public class MainActivity extends FragmentActivity implements ActionBar.TabListener {

    /**
     * The {@link android.support.v4.view.PagerAdapter} that will provide
     * fragments for each of the sections. We use a
     * {@link android.support.v4.app.FragmentPagerAdapter} derivative, which
     * will keep every loaded fragment in memory. If this becomes too memory
     * intensive, it may be best to switch to a
     * {@link android.support.v4.app.FragmentStatePagerAdapter}.
     */
    SectionsPagerAdapter mSectionsPagerAdapter;

    @Override
    protected void onStart() {
        super.onStart();
        FlurryAgent.onStartSession(this, "MMNP2W93FP5D29WJXK5J");
    }

    @Override
    protected void onStop() {
        super.onStop();
        FlurryAgent.onEndSession(this);
    }

    /**
     * The {@link ViewPager} that will host the section contents.
     */
    ViewPager mViewPager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Set up the action bar.
        final ActionBar actionBar = getActionBar();
        actionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_TABS);
        //actionBar.setDisplayShowHomeEnabled(false);
        actionBar.setDisplayShowTitleEnabled(false);

        // Create the adapter that will return a fragment for each of the three
        // primary sections of the app.
        mSectionsPagerAdapter = new SectionsPagerAdapter(getSupportFragmentManager());

        // Set up the ViewPager with the sections adapter.
        mViewPager = (ViewPager) findViewById(R.id.pager);
        mViewPager.setAdapter(mSectionsPagerAdapter);

        // When swiping between different sections, select the corresponding
        // tab. We can also use ActionBar.Tab#select() to do this if we have
        // a reference to the Tab.
        mViewPager.setOnPageChangeListener(new ViewPager.SimpleOnPageChangeListener() {
            @Override
            public void onPageSelected(int position) {
                actionBar.setSelectedNavigationItem(position);
            }
        });

        // For each of the sections in the app, add a tab to the action bar.
        for (int i = 0; i < mSectionsPagerAdapter.getCount(); i++) {
            // Create a tab with text corresponding to the page title defined by
            // the adapter. Also specify this Activity object, which implements
            // the TabListener interface, as the callback (listener) for when
            // this tab is selected.
            actionBar.addTab(
                    actionBar.newTab()
                            .setText(mSectionsPagerAdapter.getPageTitle(i))
                            .setTabListener(this));
        }

        // Growth Push
        GrowthPush.getInstance().initialize(
                getApplicationContext(),
                101,
                "efM5GGlxXyXPNmf91x6nAsHoMSiEDIZP",
                BuildConfig.DEBUG ? Environment.development : Environment.production,
                true
        ).register("flowing-diode-437");
        GrowthPush.getInstance().trackEvent("Launch");
        GrowthPush.getInstance().setDeviceTags();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }
    
    @Override
    public void onTabSelected(ActionBar.Tab tab, FragmentTransaction fragmentTransaction) {
        // When the given tab is selected, switch to the corresponding page in
        // the ViewPager.
        mViewPager.setCurrentItem(tab.getPosition());
    }

    @Override
    public void onTabUnselected(ActionBar.Tab tab, FragmentTransaction fragmentTransaction) {
    }

    @Override
    public void onTabReselected(ActionBar.Tab tab, FragmentTransaction fragmentTransaction) {
    }

    @Override
    protected void onResume() {
        super.onResume();
        checkForCrashes();
    }

    private void checkForCrashes() {
        CrashManager.register(this, "14dea5575ac697f633d1a176cd3a9ab2");
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.action_add:
                showInputDialog();
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    public void showInputDialog() {
        InputDialogFragment dialog = new InputDialogFragment();
        dialog.show(getSupportFragmentManager(),"");
    }

    public void refreshGraphFragment(){
        ((GraphFragment)mSectionsPagerAdapter.getGraphFragment()).refreshGraph();
        mViewPager.setCurrentItem(mSectionsPagerAdapter.getGraphPageIndex());
    }

    /**
     * A {@link FragmentPagerAdapter} that returns a fragment corresponding to
     * one of the sections/tabs/pages.
     */
    public class SectionsPagerAdapter extends FragmentPagerAdapter {
        private Fragment mainFragment = new MainFragment();
        private Fragment graphFragment = new GraphFragment();
        private Fragment[] items = {mainFragment, graphFragment};

        public SectionsPagerAdapter(FragmentManager fm) {
            super(fm);
        }

        public Fragment getGraphFragment() {
            return graphFragment;
        }

        public int getGraphPageIndex() {
            return 1;
        }

        @Override
        public Fragment getItem(int position) {
            if (position < 0 || position > (items.length - 1)) {
                throw new IllegalArgumentException();
            }

            Fragment fragment = items[position];
           /*
            Bundle args = new Bundle();
            args.putInt(DummySectionFragment.ARG_SECTION_NUMBER, position + 1);
            fragment.setArguments(args);
            */
            return fragment;
        }

        @Override
        public int getCount() {
            return items.length;
        }

        @Override
        public CharSequence getPageTitle(int position) {
            Locale l = Locale.getDefault();
            switch (position) {
                case 0:
                    return getString(R.string.title_home).toUpperCase();
                case 1:
                    return getString(R.string.title_graph).toUpperCase();
            }
            return null;
        }
    }
}
