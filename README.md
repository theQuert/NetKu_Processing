# News Event Triggered Knowledge Update Generation

## Processing 
- Run sentence-level difference encoding with `netku_edit.py`
- Conbine the labeled non-updated information with the updated contents: `netku_edit_post.py` to re-construct the labeled pt-format file
- Create special-token-added tokenizer with the script: `primer/script/primer_toks.py`
- Using our custom tokenizer to truncate the max sequence length to meet the **PRIMERA** requirements: *input<=4096* with *output<=1024*: `netku_edit_beftrunc.py`
- Run script to re-construcure the input data to maximum 10 paragraphs in each list from each cluster (WCEP10-like): `netku_edit_afttrunc.py`

## Source of our dataset
#### [Data](https://drive.google.com/drive/folders/1xF05auIp1EMd_KMHEaEu48J9meOsZSrU?usp=sharing)

## Bi-directional Sentence Labeling
![bidirectional_labeling](https://raw.githubusercontent.com/theQuert/NetKu_Processing/main/bi_labeling.png)

## Slides
[Google Slides](https://docs.google.com/presentation/d/1Wku83ckWwYP26hAqMmsWmURScCrNR5B7aWaKZAYEspg/edit?usp=sharing)
## References
#### [A Multi-grained Dataset for News Event Triggered Knowledge Update](https://github.com/hhhuang/NetKu)
#### [PRIMERA](https://github.com/allenai/PRIMER)
#### [NewsEdits](https://github.com/isi-nlp/NewsEdits)
#### [Updated Headline Generation: Creating Updated Summaries for Evolving News Stories](https://aclanthology.org/2022.acl-long.446)
#### [DYLE: Dynamic Latent Extraction for Abstractive Long-Input Summarization](https://ui.adsabs.harvard.edu/abs/2021arXiv211008168M)
#### [EditEval: An Instruction-Based Benchmark for Text Improvements](https://ui.adsabs.harvard.edu/abs/2022arXiv220913331D)
#### [Attention Temperature Matters in Abstractive Summarization Distillation](https://ui.adsabs.harvard.edu/abs/2021arXiv210603441Z)
#### [Graph-to-Text Generation with Dynamic Structure Pruning](https://ui.adsabs.harvard.edu/abs/2022arXiv220907258L)
