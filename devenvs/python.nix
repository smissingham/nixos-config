{
  config,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [

    # --- Python ---
    # binary installs to /run/current-system/sw/bin/python
    (python311.withPackages (
      ps: with ps; [
        numpy # these two are
        scipy # probably redundant to pandas
        pandas
        polars
        duckdb
        statsmodels
        scikitlearn

        openpyxl # pandas xlsx reader
        xlsx2csv # polars xlsx reader
        pyarrow # polars pivot

        pip
        jupyter
        jupyterlab
        ipykernel
        nbconvert
        nbformat

        # visualization
        plotly
        matplotlib
        seaborn
      ]
    ))
  ];

}
