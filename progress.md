## 2022/10/16-2022/10/23
### srcIndex < srcSelectDimsize
- The input/output may be too long (PRIMERA: `input: 4096`, `output: 1024`).
- Before fixing the spaces problem, the input and output size only work with less then 512 tokens.
- The define special token `<KEEP>`, `<ADD>`, `<SUB>`.
- Too many spaces in contents (replace '.\n\n' with '.\c\c')
- Replace '.\\c\\c' with '.\n\n' for later edit actions calculation.

### Dataset Construction
- Key: 'document', Value: 'summary'
- document:  Maximum 10 paragraphs in a list
```
[' <KEEP> The 2021 Taliban offensive is an ongoing military offensive by the Taliban and allied militant groups, including al-Qaeda, against the government of Afghanistan and its allies that began on 1 May 2021, simultaneous with the withdrawal of most U.S. troops from Afghanistan. <KEEP> As of 15 July, over a third of Afghanistans 421 districts were controlled by the Taliban, and by 21 July, half of Afghanistan was under Taliban control <KEEP>',
 'During the Afghan Civil War (1996–2001), resistance to the Taliban was strongest in northern Afghanistan, the base of the Northern Alliance. <ADD> According to the Afghanistan Analysts Network, the Talibans concentration of its forces in the north may be an attempt to forestall the creation of a second Northern Alliance after the withdrawal of U.S. forces <KEEP>',
 'In May, the Taliban captured 15 districts from the Afghan government, including Nirkh and Jalrez districts in Maidan Wardak Province. <KEEP> Among the locations captured was the Dahla Dam in Kandahar Province, Afghanistans second largest dam. <KEEP> During the month, 405 Afghan National Security Forces and 260 civilians were killed during the clashes with the Taliban, while the Afghan Ministry of Defense claimed killing 2,146 Taliban fighters <KEEP>',
 'By the end of May, Portugal, Slovenia, Spain, and Sweden had completely withdrawn their forces from Afghanistan <KEEP>',
 'In June, the Taliban captured 69 districts from the Afghan government and entered the cities of Kunduz and Puli Khumri. <KEEP> The city of Mazar-i-Sharif was besieged by Taliban. <KEEP> Among the locations captured by Taliban was Afghanistans main border crossing with Tajikistan and the Saydabad District in Maidan Wardak Province, which is called the gateway of Afghanistans capital city Kabul. <KEEP> In terms of equipment the Taliban captured 700 trucks and Humvees from the Afghan security forces as well as dozens of armored vehicles and artillery systems <KEEP>',
 'An Afghan Air Force Mil Mi-17 was shot down by the Taliban, killing three pilots, while a UH-60 Black Hawk was damaged on ground after an outpost belonging to the Afghan Armed Forces was shelled by the Taliban in the same month. <KEEP> On 16 June, Taliban militants executed 22 surrendering Afghan Army commandoes in the town of Dawlat Abad. <KEEP> During the month, 703 Afghan National Security Forces and 208 civilians were killed during the clashes with the Taliban, while the Afghan Ministry of Defense claimed killing 1,535 Taliban fighters. <KEEP> On 19 June, Afghan National Army chief of staff, defense and interior ministers were replaced by President Ashraf Ghani. <KEEP> By the end of June, all Resolute Support Missions member countries had withdrawn their troops, except for the Britain, Turkey, and the U.S <KEEP>',
 'On 22 June, the Taliban captured Shir Khan Bandar, Afghanistans main Tajikistan border crossing. <KEEP> 13 districts fell to the Taliban within 24 hours. <KEEP> On the same day, heavy fighting was also occurring in Baghlan Province after Afghan forces launched a military operation on the outskirts of Pul-e-Khumri, the provincial capital, killing 17 Taliban militants including Qari Khalid, a Taliban divisional commander. <KEEP> Simultaneously, Taliban forces took control of Balkh and encircled Mazar-i-Sharif, the capital of Balkh Province. <KEEP> On 23 June, the Taliban and Afghan forces clashed inside Pul-e Khumri <KEEP>',
 'On 25 June, the Taliban took control of the Shinwari District and the Ghorband District in Parwan province north of Kabul. <ADD> That same day NBC News reported that the Taliban "were surprised at the speed of their advance and had avoided capturing some targets so as not to run afoul of the U.S.", and the Afghan government launched a program called National Mobilization that aimed to arm militia groups to fight the Taliban. <KEEP> Meanwhile, Taliban deputy emir Sirajuddin Haqqani issued a series of instructions on Voice of Jihad for the governance of territories seized in the offensive. <ADD> FDDs Long War Journal researcher Thomas Joscelyn argued that Haqqanis statements "read like those that would be issued by the head of a nation" <KEEP>',
 'On 27 June, Chaki Wardak District and Saydabad District fell to the Taliban after at least 50 Afghan troops surrendered and were captured by the Taliban. <KEEP> On the same day Rustaq District, Shortepa District and the Arghistan District fell to the Taliban. <KEEP> ToloNews reported that 108 districts fell to the Taliban in the last two months and the Afghan army had only managed to re-take 10. <KEEP> On 29 June, the Taliban launched an offensive on Ghazni, causing violent clashes within the city <KEEP>',
 'In July, the Taliban captured 64 districts from the Afghan government and entered the second and third largest cities of Afghanistan, Kandahar and Herat respectively. <KEEP> During the month, 335 Afghan National Security Forces and 189 civilians were killed during the clashes with the Taliban, while the Afghan Ministry of Defense claimed killing 3,159 Taliban fighters. <KEEP> Around 1,500 Afghan soldiers deserted into Tajikistan, according to its CSTO envoy. <KEEP> Iranian media reported that around 300 Afghan soldiers and civilians had crossed the border and entered into Iran to escape the Taliban <KEEP>']
```
- summary: `str` format 

### Hardware problem (ECC error)
- Create new instance.

### CUDA Error
- Downgrade the CUDA version to meet Pytorch's requirements.

### Add special token to tokenizer/vocab
- Add the additional special token utilizing Huggingface's built-in function.
- Add our special token to tokenizer, then update the `vocab.json`. Then use the updated tokenizer to do truncation and encoding.

### Applied method and Next step
- Replace '.\n\n' with '.\c\c' to fix the srcIndex problem.
- Special tokens are not added successfully, the built-in function may not work. *Sol: Try to utilize the updated tokenizer in the main model*
- The #outupts is more then given #instances, still needed to debug. 

### Methods of adding special tokens to tokenizer
- Huggingface's built-in function

```Python
self.docsep_token_id = self.tokenizer.convert_tokens_to_ids("<doc-sep>")
self.tokenizer.add_special_tokens({'additional_special_tokens': ["<KEEP>", "<ADD>", "<SUB>"]})
self.model.resize_token_embeddings(len(self.tokenizer))
self.keep_token_id = self.tokenizer.convert_tokens_to_ids("<KEEP>")
self.add_token_id = self.tokenizer.convert_tokens_to_ids("<ADD>")
self.sub_token_id = self.tokenizer.convert_tokens_to_ids("<SUB>")

attention_mask[input_ids == self.docsep_token_id] = 2
attention_mask[input_ids == self.keep_token_id] = 2
attention_mask[input_ids == self.add_token_id] = 2
attention_mask[input_ids == self.sub_token_id] = 2
```
- Update existed tokenizer, and `vocab.json`

```Python
tokenizer = AutoTokenizer.from_pretrained('../PRIMER_wcep')
model = LongformerEncoderDecoderForConditionalGeneration.from_pretrained('../PRIMER_wcep')
tokenizer.add_tokens(['<KEEP>', '<ADD>', '<SUB>'])
model.resize_token_embeddings(len(tokenizer))
model.save_pretrained('../PRIMER_wcep/new')
tokenizer.save_pretrained('../PRIMER_wcep/new')
```

## 2022/10/23-2022/10/30
### Find the indices of paragraphs which needed to be updated (reconstruct new dataset)
- Calculate the edit actions for each paragraphs (the `top-3` or `top-5` paragraphs).
- Construct new dataset to fine-tune PRIMERA. (modify the sliding window is optional)
## Solution to special token
- By construncting a new dataset, the sepcial tokens are no longer to be encoded.
### Length Problem
- If we extract the `top-3`/`top-5` paragraphs, the length are short enough for model compared with the full-content scale.
### Goal
- The original goal is unchanged, but we divide the task into 3 steps:
1. Apply the labeling algorithm on sentence-level annotation.
2. Re-construnct our datset (consists of the paragraphs which more needed to be updated).
3. Merge the output with our original dataset, then prove our method is capable to update an full-article given its old version and the triggered news event.