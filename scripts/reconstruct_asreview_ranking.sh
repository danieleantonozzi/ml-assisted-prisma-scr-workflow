python3 - <<'PY'
from tempfile import TemporaryDirectory
import asreview as asr

fp = "260214_MY_DATASET_3740_REV.asreview" 
with asr.open_state(fp) as st:
    ranking = st.get_last_ranking_table()[["record_id", "ranking"]]
    results = st.get_results_table(columns=["record_id", "label", "time"])

with TemporaryDirectory() as tmp:
    project = asr.Project.load(fp, tmp)
    data = project.data_store.get_df()

out = (ranking
       .merge(results, on="record_id", how="left")
       .merge(data, on="record_id", how="left")
       .sort_values("ranking"))

out.to_csv("asreview_global_ranking.csv", index=False)
print("Created: asreview_global_ranking.csv")
PY
