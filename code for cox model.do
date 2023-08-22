summarize
misstable summarize
drop if smoke ==.
drop if sysbp ==.
drop if bmi ==.
summ

sum bmi
mean bmi
hist bmi
gen bmicat=bmi
recode bmicat min/24.99999=1 25/29.99999=2 30/max=3
label define bmicat 1 "underweight" 2 "normal weight" 3 "overweight"
label values bmicat bmicat
tab bmicat

sum sbp, detail
hist sbp, normal 
mean sbp
gen sbpcat=sysbp
recode sbpcat min/139.99999=1 140/max=2
label define sbpcat 1 "normal" 2 "hypertension"
label values sbpcat sbpcat
tab sbpcat

gen RDDcat1=relapse_days_diff
recode RDDcat1 min/364.99=1 365/729.99=2 730/max=3 
label define RDDcat1 1 "1 year" 2 "2 year" 3 "3 year and more" 
label values RDDcat1 RDDcat1
tab RDDcat1

label values sex .
label values smoke . 
label values PC_event .
label values age_cat_2008 .
label values antidepressants_binary .

gen relapse_cat = relapse_num
recode relapse_cat 0=0 1=1 2/max=2
tab relapse_cat

gen relapse_bin = relapse_num > 0
tab relapse_bin
gen relapse_cens = 1-relapse_bin
tab relapse_cens

generate time = min(relapse_date, stend) - ststart
summ time

ssc install stcstat2
adoupdate stcstat2, update

stset time, failure(relapse_bin)
stsum

power cox 0.75, n(32249) sd(0.2) eventprob(0.21560358) r2(0.3) onesided



stcox cmb_1 cmb_2 cmb_3 cmb_4 cmb_5 cmb_6 cmb_7 cmb_8 cmb_9 i.sex i.age_cat_2008 i.smoke i.townsend_num i.RDDcat1 presc_index_value i.sbpcat i.bmicat PC_event antidepressants_binary, schoenfeld(sc_1*) scaledsch(ssc_1*)
stphtest, rank detail
Test of proportional-hazards assumption

Time function: Rank of analysis time
--------------------------------------------------------
             |        rho     chi2       df    Prob>chi2
-------------+------------------------------------------
       cmb_1 |    0.00592     0.24        1       0.6228
       cmb_2 |   -0.01704     2.01        1       0.1559
       cmb_3 |   -0.02470     4.21        1       0.0401
       cmb_4 |    0.02660     5.10        1       0.0239
       cmb_5 |   -0.00694     0.34        1       0.5589
       cmb_6 |   -0.04815    16.31        1       0.0001
       cmb_7 |   -0.00614     0.26        1       0.6083
       cmb_8 |    0.00385     0.10        1       0.7504
       cmb_9 |    0.00573     0.23        1       0.6324
      1b.sex |          .        .        1           .
       2.sex |    0.00481     0.16        1       0.6882
1b.age_~2008 |          .        .        1           .
2.age_c~2008 |   -0.00133     0.01        1       0.9119
3.age_c~2008 |    0.00130     0.01        1       0.9140
4.age_c~2008 |   -0.00880     0.54        1       0.4626
5.age_c~2008 |    0.00870     0.52        1       0.4691
6.age_c~2008 |    0.00299     0.06        1       0.8025
7.age_c~2008 |    0.02575     4.73        1       0.0296
8.age_c~2008 |    0.00367     0.09        1       0.7584
9.age_c~2008 |   -0.00005     0.00        1       0.9964
10.age_~2008 |   -0.00011     0.00        1       0.9924
    1b.smoke |          .        .        1           .
     2.smoke |    0.00944     0.63        1       0.4291
     3.smoke |    0.01282     1.15        1       0.2840
1b.townsen~m |          .        .        1           .
2.townsend~m |    0.00357     0.09        1       0.7660
3.townsend~m |    0.00068     0.00        1       0.9544
4.townsend~m |    0.00273     0.05        1       0.8198
5.townsend~m |    0.00386     0.10        1       0.7474
  1b.RDDcat1 |          .        .        1           .
   2.RDDcat1 |    0.44265  1760.42        1       0.0000
   3.RDDcat1 |    0.64818  3233.86        1       0.0000
presc_inde~e |   -0.01361     1.33        1       0.2496
   1b.sbpcat |          .        .        1           .
    2.sbpcat |    0.00640     0.28        1       0.5943
   1b.bmicat |          .        .        1           .
    2.bmicat |   -0.00311     0.07        1       0.7955
    3.bmicat |    0.00098     0.01        1       0.9343
    PC_event |    0.01804     2.25        1       0.1332
antidepres~y |   -0.02094     3.00        1       0.0830
-------------+------------------------------------------
 Global test |             3621.82       33       0.0000
--------------------------------------------------------

stcox cmb_1 cmb_2 cmb_5 cmb_7 cmb_8 cmb_9 i.sex i.age_cat_2008 i.smoke i.townsend_num i.sbpcat i.bmicat i.PC_event antidepressants_binary
estat concordance //Harell's C = 0.5368
predict xb, xb
stcoxcal xb, times(365 730 1825 2920 3650) test

stcox cmb_1 cmb_2 cmb_5 cmb_7 cmb_8 cmb_9 i.sex i.age_cat_2008 i.smoke i.townsend_num i.sbpcat i.bmicat i.PC_event antidepressants_binary, tvc(cmb_3 cmb_4 cmb_6 RDDcat1)

        Failure _d: relapse_bin
  Analysis time _t: time

Iteration 0:   log likelihood = -67195.575
Iteration 1:   log likelihood = -66662.047
Iteration 2:   log likelihood = -63827.615
Iteration 3:   log likelihood = -63020.357
Iteration 4:   log likelihood = -63006.617
Iteration 5:   log likelihood = -63006.583
Refining estimates:
Iteration 0:   log likelihood = -63006.583

Cox regression with Breslow method for ties

No. of subjects =     32,249                           Number of obs =  32,249
No. of failures =      6,953
Time at risk    = 40,212,299
                                                       LR chi2(31)   = 8377.98
Log likelihood = -63006.583                            Prob > chi2   =  0.0000

----------------------------------------------------------------------------------------
                    _t | Haz. ratio   Std. err.      z    P>|z|     [95% conf. interval]
-----------------------+----------------------------------------------------------------
main                   |
                 cmb_1 |   .9616752   .0374052    -1.00   0.315     .8910871    1.037855
                 cmb_2 |   1.037983   .0306878     1.26   0.207     .9795454    1.099907
                 cmb_5 |   1.104719    .034984     3.14   0.002     1.038236    1.175459
                 cmb_7 |   .9943536   .0387316    -0.15   0.884     .9212665    1.073239
                 cmb_8 |   .9261758   .0301158    -2.36   0.018     .8689914    .9871232
                 cmb_9 |   1.128639   .1697103     0.80   0.421     .8405472    1.515471
                       |
                   sex |
                women  |   .9556948   .0240153    -1.80   0.071      .909766    1.003942
                       |
          age_cat_2008 |
                55-60  |   .9024069   .0323153    -2.87   0.004     .8412416    .9680194
                60-65  |   .9558559   .0367948    -1.17   0.241     .8863927    1.030763
                65-70  |   .9329377   .0407286    -1.59   0.112      .856431    1.016279
                70-75  |   .9508988   .0446066    -1.07   0.283     .8673702    1.042471
                75-80  |   .8559304   .0465614    -2.86   0.004     .7693684    .9522315
                80-85  |   .8625103   .0604762    -2.11   0.035     .7517631    .9895723
                85-90  |   .7244696     .09356    -2.50   0.013     .5624626    .9331397
                90-95  |    .793602   .2411004    -0.76   0.447     .4375255    1.439468
                95-99  |   1.419944   1.006066     0.49   0.621     .3541388    5.693361
                       |
                 smoke |
            Ex-smoker  |   1.086367   .0311874     2.89   0.004     1.026929    1.149246
       Current smoker  |    1.07617   .0354723     2.23   0.026     1.008844    1.147989
                       |
          townsend_num |
                    2  |   .9357525   .0333535    -1.86   0.062     .8726121    1.003462
                    3  |   .9577717   .0342064    -1.21   0.227     .8930211    1.027217
                    4  |   .8939443   .0337636    -2.97   0.003     .8301588    .9626307
                    5  |   .8779118   .0372386    -3.07   0.002     .8078771    .9540178
                       |
              2.sbpcat |   .9951419   .0246115    -0.20   0.844     .9480548    1.044568
                       |
                bmicat |
                    2  |   1.003577   .0306988     0.12   0.907     .9451766    1.065586
                    3  |   1.046958   .0338846     1.42   0.156      .982608    1.115522
                       |
              PC_event |
                  yes  |   .9434862   .0573201    -0.96   0.338     .8375718    1.062794
antidepressants_binary |   .9194381   .0252258    -3.06   0.002     .8713023    .9702332
-----------------------+----------------------------------------------------------------
tvc                    |
                 cmb_3 |   .9999839   .0000233    -0.69   0.491     .9999382     1.00003
                 cmb_4 |    1.00021   .0000349     6.02   0.000     1.000142    1.000278
                 cmb_6 |   .9999491    .000026    -1.96   0.050     .9998982           1
               RDDcat1 |   1.001056   .0000134    78.60   0.000      1.00103    1.001082
----------------------------------------------------------------------------------------

//C index
somersd _t _d, tr(c) //Somer's D=0.4738, C-index = 0.5 + Somers' D / 2 = 0.5 + 0.4738 / 2 C-index = 0.7369

predict xb1, xb1
stcoxcal xb1, times(365 730 1825 2920 3650) test

//Univariate
stcox cmb_1
stcox cmb_2
stcox cmb_3
stcox cmb_4
stcox cmb_5
stcox cmb_6
stcox cmb_7
stcox cmb_8
stcox cmb_9

stcox i.sex
stcox i.age_cat_2008
stcox i.smoke
stcox i.townsend_num

stcox i.RDDcat1
stcox presc_index_value
stcox i.sbpcat
stcox i.bmicat
stcox PC_event
stcox antidepressants_binary

stcox cmb_3 cmb_4 cmb_5 cmb_6 i.sex i.age_cat_2008 i.smoke i.RDDcat sbpcat PC_event antidepressants_binary, schoenfeld(sc_1*) scaledsch(ssc_1*)
stphtest, rank detail
Test of proportional-hazards assumption

Time function: Rank of analysis time
--------------------------------------------------------
             |        rho     chi2       df    Prob>chi2
-------------+------------------------------------------
       cmb_3 |   -0.02540     4.41        1       0.0358
       cmb_4 |    0.02517     4.57        1       0.0326
       cmb_5 |   -0.00597     0.25        1       0.6153
       cmb_6 |   -0.04937    17.08        1       0.0000
      1b.sex |          .        .        1           .
       2.sex |    0.00780     0.42        1       0.5151
1b.age_~2008 |          .        .        1           .
2.age_c~2008 |   -0.00339     0.08        1       0.7776
3.age_c~2008 |   -0.00187     0.02        1       0.8767
4.age_c~2008 |   -0.01319     1.21        1       0.2720
5.age_c~2008 |    0.00458     0.14        1       0.7035
6.age_c~2008 |   -0.00134     0.01        1       0.9107
7.age_c~2008 |    0.02253     3.62        1       0.0571
8.age_c~2008 |    0.00174     0.02        1       0.8841
9.age_c~2008 |   -0.00094     0.01        1       0.9376
10.age_~2008 |   -0.00055     0.00        1       0.9634
    1b.smoke |          .        .        1           .
     2.smoke |    0.00879     0.54        1       0.4627
     3.smoke |    0.01159     0.93        1       0.3340
  1b.RDDcat1 |          .        .        1           .
   2.RDDcat1 |    0.44335  1766.63        1       0.0000
   3.RDDcat1 |    0.64908  3239.01        1       0.0000
      sbpcat |    0.00699     0.34        1       0.5610
    PC_event |    0.01613     1.82        1       0.1771
antidepres~y |   -0.02154     3.19        1       0.0739
-------------+------------------------------------------
 Global test |             3620.59       21       0.0000
--------------------------------------------------------



stcox cmb_3 cmb_4 cmb_5 cmb_6 i.sex i.age_cat_2008 i.smoke i.RDDcat1 sbpcat PC_event antidepressants_binary, strata(cmb_3 cmb_4 cmb_6 RDDcat1)
estat concordance //harrell's C = 0.5215

stcox cmb_3 cmb_4 cmb_5 cmb_6 i.sex i.age_cat_2008 i.smoke i.RDDcat1 sbpcat PC_event antidepressants_binary, strata(cmb_3 cmb_4 cmb_6 RDDcat1)
predict xb2, xb2
stcoxcal xb, times(365 730 1825 2920 3650) test

//Visualization
sts graph, strata(cmb_3) adjust(cmb_4 cmb_5 cmb_6 i.sex i.age_cat_2008 i.smoke i.RDDcat1 sbpcat PC_event antidepressants_binary)
sts graph, strata(cmb_4) adjust(cmb_3 cmb_5 cmb_6 i.sex i.age_cat_2008 i.smoke i.RDDcat1 sbpcat PC_event antidepressants_binary)
sts graph, strata(cmb_6) adjust(cmb_3 cmb_4 cmb_5 i.sex i.age_cat_2008 i.smoke i.RDDcat1 sbpcat PC_event antidepressants_binary)
sts graph, strata(RDDcat1) adjust(cmb_3 cmb_4 cmb_5 cmb_6 i.sex i.age_cat_2008  sbpcat PC_event antidepressants_binary)

stphplot, strata(cmb_3) adjust(cmb_4 cmb_5 cmb_6 i.sex i.age_cat_2008 i.smoke i.RDDcat1 sbpcat PC_event antidepressants_binary) nonegative nolntime
stphplot, strata(cmb_4) adjust(cmb_3 cmb_5 cmb_6 i.sex i.age_cat_2008 i.smoke i.RDDcat1 sbpcat PC_event antidepressants_binary) nonegative nolntime
stphplot, strata(cmb_6) adjust(cmb_3 cmb_4 cmb_6 i.sex i.age_cat_2008 i.smoke i.RDDcat1 sbpcat PC_event antidepressants_binary) nonegative nolntime
stphplot, strata(RDDcat1) adjust(cmb_3 cmb_4 cmb_6 i.sex i.age_cat_2008 i.smoke sbpcat PC_event antidepressants_binary) nonegative nolntime

stcox cmb_3 cmb_4 cmb_5 i.sex i.age_cat_2008 i.smoke i.RDDcat1 sbpcat PC_event antidepressants_binary, tvc(cmb_3 cmb_4 cmb_6 RDDcat1)
stcoxgrp, by(RDDcat1) n(10) graph varlist(cmb_3 cmb_4 cmb_5 i.sex i.age_cat_2008 i.smoke i.RDDcat1 sbpcat PC_event antidepressants_binary)


findit somersd
help somersd

Harell C index


