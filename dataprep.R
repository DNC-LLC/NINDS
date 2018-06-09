# Prepare NINDS data

load("./NINDSCCTR/tclemons/tPA/ninds.rdata")
names(ninds) <- tolower(names(ninds))
rownames(ninds) <- ninds$record
ninds$record <- NULL

library(rms)

# Read SAS data labels extracted by Stat/Transfer VAR command
labs <- read.delim("nindsvars.dat", header=FALSE, stringsAsFactors=FALSE)
ninds <- upData(ninds,
                bdiab = bdiab==100,
                bhyper = bhyper==100,
                bmi = bmi==100,
                bangina = bangina==100,
                bcong = bcong==100,
                aspirin = aspirin==100,
                nsthx = nsthx==100,
                ntiahx = ntiahx==100,
                patrial = patrial==100,
                cursmker = cursmker==100,
                nopdis = nopdis==100)

ninds <- upData(ninds
                ,treatcd = ordered(treatcd, levels=2:1, labels=c('Placebo','t-PA'))
                ,treated = treatcd=='t-PA' # TODO: drop if I find an 'official' version
                ,bgender = factor(bgender, levels=1:2, labels=c('female','male'))
                ,brace = factor(brace, levels=1:5, labels=c('Black','White','Hispanic','Asian','Other'))
                ,tdx = factor(tdx, levels=1:4, labels=c('Small vessel occlusive',
                                                        'Cardioembolic',
                                                        'Large vessel occlusive',
                                                        'Other'))
                ,ctedema = ctedema==1
                ,ctmassef = ctmassef==1
                # TODO: Consider an ordered factor NA:=None < Asymp < Symp
                ,symp = factor(symp, levels=1:2, labels=c('Symp','Asymp'))
                ,syfatal = syfatal==1
                ,primary_ = factor(primary_, levels=1:6, labels=c('Cerebrovascular',
                                                                  'Cardiovascular',
                                                                  'Infection',
                                                                  'Cancer',
                                                                  'Respiratory',
                                                                  'Other'))
                ,dcensor = dcensor==1
                ,bather = bather==1
                ,drink = drink==1
                ,ostrk = ostrk==1
                ,cardiac = cardiac==1
                ,ctfind = ctfind==1
                ,ctfind2 = ctfind2==1
                ,bprob = bprob==100
                ,bchol = bchol==1
                ,bhep = bhep==1
                ,bmal = bmal==1
                ,bhema = bhema==1
                ,bprior = bprior==1
                ,heparin = heparin==1
                ,ppros = ppros==1
                ,preccb = preccb==1
                ,heminfar = heminfar==1
                ,intrama = intrama==1
                ,type1hem = !is.na(type1hem)
                ,flike = factor(flike, levels=1:7, labels=c('Small Vessel Occlusive Disease',
                                                            'Cardioembolic Stroke',
                                                            'Large Vessel Atherosclerosis',
                                                            'Tandem Lesion Stroke',
                                                            'Stroke with Normal Arteries',
                                                            'Other Identified Cause',
                                                            'Unknown Cause'))
                ,hypersgn = hypersgn==1
                ,lossgrwt = lossgrwt==1
                ,mca33 = mca33==1
                ,hypodens = hypodens==1
                ,hyp33 = hyp33==1
                ,csfcomp = csfcomp==1
                ,csf33 = csf33==1
                ,earlyctf = earlyctf==1
                ,early33 = early33==1
                ,ctmidshf = ctmidshf==1
                ,cthyper = cthyper==1
                ,ctthrom = ctthrom==1
                ,findings = findings==1
                ,abnormal = abnormal==1
                ,hdchg = ordered(hdchg, levels=1:6, labels=c('Home','Relative/Friend',
                                                             'Rehab','Nursing Home',
                                                             'Death','Other'))
                ,newstrk = newstrk==1
                ,ect = ect==1
                ,phand = factor(phand, levels=1:3, labels=c('Left','Right','Ambidextrous'))
                ,tloc = factor(tloc, levels=c(1,2,3,9), labels=c('Left','Right',
                                                                 'Brainstem','Unkown'))
                ,post36 = post36==100
                ,preagtrt = preagtrt==100
                ,event = event==100
                ,aht = aht==100
                ,nih1 = nih1==1
                ,b95 = b95==1
                ,edema24 = edema24==1
                ,massef24 = massef24==1
                ,midshf24 = midshf24==1
                ,hyper24 = hyper24==1
                ,throm24 = throm24==1
                ,dfi = dfi==100
                ,dficau = factor(dficau, levels=1:4, labels=c('Hemorrhage','Edema',
                                                              'Reocclusion','Other'))
                ,dfireocc = dfireocc==100
                ,dfiother = dfiother==100
                ,hemint = ordered(hemint, levels=0:7, labels=c('None','<6h','6-12h',
                                                               '12-24h','24-36h','36h-7d',
                                                               '7d-3mo','>3mo'))
                # TODO: Convert Barthel index components (AFEED..YBLADDER) to ordered factors.
                )

# Neuro exam detail (starts with sconscio_base)
# ...

# Drop stupid or redundant variables, and label the rest
names(labs) <- c("var", "label")
labels = labs$label
names(labels) <- tolower(labs$var)
ninds <- upData(ninds,
                drop = c('stratum','nihgrp','nihgrp20',
                         'd24hrs','d2hrs','d7ds','d90ds',
                         'bpdrop','admbp','admdia','dia',
                         'rankin1','dfi24','reocc24','other24',
                         'det24','det710','asymp36'),
                labels = labels)


# Add units where helpful, removing them from labels when present

# Write to disk
save(ninds, file="ninds.Rdata")
