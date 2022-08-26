library(tidyverse)
library(plyr)
library(fs)
library(janitor)
library(stringr)
library(matrixStats)
library(arrow)
library(sparklyr)
library(gganimate)
library(REdaS)
library(zoo)
library(umap)
library(caret)
library(rsample)
library(nnet)
library(MLmetrics)

#devtools::install_github("thomasp85/transformr")



#### READ INDIVIDUAL SHOT TRAJECTORY DATA

getwd()

mydir = "pose_data/qb_class_results/"

csv_file_list<-dir_ls(mydir)


df_list<-purrr::map(csv_file_list,read_csv)


df<-rbind(df_list$`pose_data/qb_class_results/Anthony Gordon_Combine_2020_1.csv`,
             df_list$`pose_data/qb_class_results/Baker Mayfield_Combine_2018_1.csv`,
             df_list$`pose_data/qb_class_results/Baker Mayfield_Combine_2018_2.csv`,
             df_list$`pose_data/qb_class_results/Baker Mayfield_Combine_2018_3.csv`,
             df_list$`pose_data/qb_class_results/Baker Mayfield_Combine_2018_4.csv`,
            df_list$`pose_data/qb_class_results/Brian Lewerke_Combine_2019_1.csv`,
          df_list$`pose_data/qb_class_results/Brian Lewerke_Combine_2019_2.csv`,
          df_list$`pose_data/qb_class_results/CJ Beathard_Combine_2017_1.csv`,
          df_list$`pose_data/qb_class_results/CJ Beathard_Combine_2017_2.csv`,
          df_list$`pose_data/qb_class_results/Carson Wentz_Combine_2016_1.csv`,
          df_list$`pose_data/qb_class_results/Carson Wentz_Combine_2016_2.csv`,
          df_list$`pose_data/qb_class_results/Carson Wentz_Combine_2016_3.csv`,
          df_list$`pose_data/qb_class_results/Carson Wentz_Combine_2016_4.csv`,
          df_list$`pose_data/qb_class_results/Carson Wentz_Combine_2016_5.csv`,
          df_list$`pose_data/qb_class_results/Carson Wentz_Combine_2016_6.csv`,
          df_list$`pose_data/qb_class_results/Carson Wentz_Combine_2016_7.csv`,
          df_list$`pose_data/qb_class_results/Carson Wentz_Combine_2016_8.csv`,
          df_list$`pose_data/qb_class_results/Carson Wentz_Combine_2016_9.csv`,
          df_list$`pose_data/qb_class_results/Cole Kelley_Combine_2022_1.csv`,
          df_list$`pose_data/qb_class_results/Dak Prescott_Combine_2016_1.csv`,
          df_list$`pose_data/qb_class_results/Dak Prescott_Combine_2016_2.csv`,
          df_list$`pose_data/qb_class_results/Deshaun Watson_Combine_2017_1.csv`,
          df_list$`pose_data/qb_class_results/Deshaun Watson_Combine_2017_2.csv`,
          df_list$`pose_data/qb_class_results/Deshaun Watson_Combine_2017_3.csv`,
          df_list$`pose_data/qb_class_results/Drew Lock_Combine_2019_1.csv`,
          df_list$`pose_data/qb_class_results/Drew Lock_Combine_2019_2.csv`,
          df_list$`pose_data/qb_class_results/Drew Lock_Combine_2019_3.csv`,
          df_list$`pose_data/qb_class_results/Dwayne Haskins_Combine_2019_1.csv`,
          df_list$`pose_data/qb_class_results/Dwayne Haskins_Combine_2019_2.csv`,
          df_list$`pose_data/qb_class_results/Dwayne Haskins_Combine_2019_3.csv`,
          df_list$`pose_data/qb_class_results/Jack Coan_Combine_2022_1.csv`,
          df_list$`pose_data/qb_class_results/Jacob Eason_Combine_2020_1.csv`,
          df_list$`pose_data/qb_class_results/Jake Fromm_Combine_2020_1.csv`,
          df_list$`pose_data/qb_class_results/Jake Fromm_Combine_2020_2.csv`,
          df_list$`pose_data/qb_class_results/Jalen Hurts_Combine_2020_1.csv`,
          df_list$`pose_data/qb_class_results/Jameis Winston_Combine_2015_1.csv`,
          df_list$`pose_data/qb_class_results/Jameis Winston_Combine_2015_2.csv`,
          df_list$`pose_data/qb_class_results/Jameis Winston_Combine_2015_3.csv`,
          df_list$`pose_data/qb_class_results/Jameis Winston_Combine_2015_4.csv`,
          df_list$`pose_data/qb_class_results/Jameis Winston_Combine_2015_5.csv`,
          df_list$`pose_data/qb_class_results/Jameis Winston_Combine_2015_6.csv`,
          df_list$`pose_data/qb_class_results/Jameis Winston_Combine_2015_7.csv`,
          df_list$`pose_data/qb_class_results/Jared Goff_Combine_2016_1.csv`,
          df_list$`pose_data/qb_class_results/Jerod Evans_Combine_2017_1.csv`,
          df_list$`pose_data/qb_class_results/Jerod Evans_Combine_2017_2.csv`,
          df_list$`pose_data/qb_class_results/Josh Allen_Combine_2018_1.csv`,
          df_list$`pose_data/qb_class_results/Josh Allen_Combine_2018_2.csv`,
          df_list$`pose_data/qb_class_results/Josh Rosen_Combine_2018_1.csv`,
          df_list$`pose_data/qb_class_results/Josh Rosen_Combine_2018_2.csv`,
          df_list$`pose_data/qb_class_results/Joshua Dobbs_Combine_2017_1.csv`,
          df_list$`pose_data/qb_class_results/Joshua Dobbs_Combine_2017_2.csv`,
          df_list$`pose_data/qb_class_results/Justin Herbert_Combine_2020_1.csv`,
          df_list$`pose_data/qb_class_results/Kenny Pickett_Combine_2022_1.csv`,
          df_list$`pose_data/qb_class_results/Lamar Jackson_Combine_2018_1.csv`,
          df_list$`pose_data/qb_class_results/Lamar Jackson_Combine_2018_2.csv`,
          df_list$`pose_data/qb_class_results/Lamar Jackson_Combine_2018_3.csv`,
          df_list$`pose_data/qb_class_results/Lamar Jackson_Combine_2018_4.csv`,
          df_list$`pose_data/qb_class_results/Malik Willis_Combine_2022_1.csv`,
          df_list$`pose_data/qb_class_results/Malik Willis_Combine_2022_2.csv`,
          df_list$`pose_data/qb_class_results/Marcus Mariota_Combine_2015_1.csv`,
          df_list$`pose_data/qb_class_results/Marcus Mariota_Combine_2015_2.csv`,
          df_list$`pose_data/qb_class_results/Marcus Mariota_Combine_2015_3.csv`,
          df_list$`pose_data/qb_class_results/Marcus Mariota_Combine_2015_4.csv`,
          df_list$`pose_data/qb_class_results/Marcus Mariota_Combine_2015_5.csv`,
          df_list$`pose_data/qb_class_results/Marcus Mariota_Combine_2015_6.csv`,
          df_list$`pose_data/qb_class_results/Marcus Mariota_Combine_2015_7.csv`,
          df_list$`pose_data/qb_class_results/Mitch Leidner_Combine_2017_1.csv`,
          df_list$`pose_data/qb_class_results/Mitch Leidner_Combine_2017_2.csv`,
          df_list$`pose_data/qb_class_results/Mitch Trubisky_Combine_2017_1.csv`,
          df_list$`pose_data/qb_class_results/Mitch Trubisky_Combine_2017_2.csv`,
          df_list$`pose_data/qb_class_results/Nathan Peterman_Combine_2017_1.csv`,
          df_list$`pose_data/qb_class_results/Nathan Peterman_Combine_2017_2.csv`,
          df_list$`pose_data/qb_class_results/Nick Foles_Combine_2012_1.csv`,
          df_list$`pose_data/qb_class_results/Nick Marshall_Combine_2015_1.csv`,
          df_list$`pose_data/qb_class_results/Patrick Mahomes_Combine_2017_1.csv`,
          df_list$`pose_data/qb_class_results/Paxton Lynch_Combine_2016_1.csv`,
          df_list$`pose_data/qb_class_results/Paxton Lynch_Combine_2016_2.csv`,
          df_list$`pose_data/qb_class_results/Paxton Lynch_Combine_2016_3.csv`,
          df_list$`pose_data/qb_class_results/Paxton Lynch_Combine_2016_4.csv`,
          df_list$`pose_data/qb_class_results/Paxton Lynch_Combine_2016_5.csv`,
          df_list$`pose_data/qb_class_results/Paxton Lynch_Combine_2016_6.csv`,
          df_list$`pose_data/qb_class_results/Sam Howell_Combine_2012_1.csv`,
          df_list$`pose_data/qb_class_results/Sefo Liufau_Combine_2017_1.csv`,
          df_list$`pose_data/qb_class_results/Trace Mcsorley_Combine_2019_1.csv`,
          df_list$`pose_data/qb_class_results/Trevor Knight_Combine_2017_1.csv`,
          df_list$`pose_data/qb_class_results/Will Grier_Combine_2019_1.csv`)

### 86 unique throws

#### clean data
throws<-df %>%
  dplyr::filter(complete.cases(`0`)) %>%
  group_by(name,event,throw_number) %>%
  mutate(row = row_number()) %>%
  ungroup() %>%
    mutate(
      ######## TIME CONVERSION
      time = row / fps,
      throw_id = paste0(name,"_",event,"_",throw_number),
      ##### add in file dimensions ####
    ######### convert 3D to 2D scale  #########
    ## coord 1
    nose_x = nose_x1 / nose_z1,
    nose_y = nose_y1 / nose_z1,
    ## coord 2
    left_eye_inner_x = left_eye_inner_x2 / left_eye_inner_z2,
    left_eye_inner_y = left_eye_inner_y2 / left_eye_inner_z2,
    ## coord 3
    left_eye_x = left_eye_x3 / left_eye_z3,
    left_eye_y = left_eye_y3 / left_eye_z3,
    ## coord 4
    left_eye_outer_x = left_eye_outer_x4 / left_eye_outer_z4,
    left_eye_outer_y = left_eye_outer_y4 / left_eye_outer_z4,
    ## coord 5
    right_eye_inner_x = right_eye_inner_x5 / right_eye_inner_z5,
    right_eye_inner_y = right_eye_inner_y5 / right_eye_inner_z5,
    ## coord 6
    right_eye_x = right_eye_x6 / right_eye_z6,
    right_eye_y = right_eye_y6 / right_eye_z6,    
    ## coord 7
    right_eye_outer_x = right_eye_outer_x7 / right_eye_outer_z7,
    right_eye_outer_y = right_eye_outer_y7 / right_eye_outer_z7,  
    ## coord 8
    left_ear_x = left_ear_x8 / left_ear_z8,
    left_ear_y = left_ear_y8 / left_ear_z8,
    ## coord 9
    right_ear_x = right_ear_x9 / right_ear_z9,
    right_ear_y = right_ear_y9 / right_ear_z9,
    ## coord 10
    mouth_left_x = mouth_left_x10 / mouth_left_z10,
    mouth_left_z = mouth_left_y10 / mouth_left_z10,
    ## coord 11
    mouth_right_x = mouth_right_x11 / mouth_right_z11,
    mouth_right_y = mouth_right_y11 / mouth_right_z11,
    ## coord 12
    left_shoulder_x = left_shoulder_x12 / left_shoulder_z12,
    left_shoulder_y = left_shoulder_y12 / left_shoulder_z12,
    ## coord 13
    right_shoulder_x = right_shoulder_x13 / right_shoulder_z13,
    right_shoulder_y = right_shoulder_y13 / right_shoulder_z13,
    ## coord 14
    left_elbow_x = left_elbow_x14 / left_elbow_z14,
    left_elbow_y = left_elbow_y14 / left_elbow_z14,
    ## coord 15
    right_elbow_x = right_elbow_x15 / right_elbow_z15,
    right_elbow_y = right_elbow_y15 / right_elbow_z15,
    ## coord 16
    left_wrist_x = left_wrist_x16 / left_wrist_z16,
    left_wrist_y = left_wrist_y16 / left_wrist_z16,
    ## coord 17
    right_wrist_x = right_wrist_x17 / right_wrist_z17,
    right_wrist_y = right_wrist_y17 / right_wrist_z17,
    ## coord 18
    left_pinky_x = left_pinky_x18 / left_pinky_z18,
    left_pinky_y = left_pinky_y18 / left_pinky_z18,
    ## coord 19
    right_pinky_x = right_pinky_x19 / right_pinky_z19,
    right_pinky_y = right_pinky_y19 / right_pinky_z19,
    ## coord 20
    left_index_x = left_index_x20 / left_index_z20,
    left_index_y = left_index_y20 / left_index_z20,  
    ## coord 21
    right_index_x = right_index_x21 / right_index_z21,
    right_index_y = right_index_y21 / right_index_z21,  
    ## coord 22
    left_thumb_x = left_thumb_x22 / left_thumb_z22,
    left_thumb_y = left_thumb_y22 / left_thumb_z22,  
    ## coord 23
    right_thumb_x = right_thumb_x23 / right_thumb_z23,
    right_thumb_y = right_thumb_y23 / right_thumb_z23,      
    ## coord 24
    left_hip_x = left_hip_x24 / left_hip_z24,
    left_hip_y = left_hip_y24 / left_hip_z24,    
    ## coord 25
    right_hip_x = right_hip_x25 / right_hip_z25,
    right_hip_y = right_hip_y25 / right_hip_z25,
    ## coord 26
    left_knee_x = left_knee_x26 / left_knee_z26,
    left_knee_y = left_knee_y26 / left_knee_z26,
    ## coord 27
    right_knee_x = right_knee_x27 / right_knee_z27,
    right_knee_y = right_knee_y27 / right_knee_z27,  
    ## coord 28
    left_ankle_x = left_ankle_x28 / left_ankle_z28,
    left_ankle_y = left_ankle_y28 / left_ankle_z28,
    ## coord 29
    right_ankle_x = right_ankle_x29 / right_ankle_z29,
    right_ankle_y = right_ankle_y29 / right_ankle_z29,
    ## coord 30
    left_heel_x = left_heel_x30 / left_heel_z30,
    left_heel_y = left_heel_y30 / left_heel_z30,  
    ## coord 31
    right_heel_x = right_heel_x31 / right_heel_z31,
    right_heel_y = right_heel_y31 / right_heel_z31, 
    ## coord 32
    left_foot_index_x = left_foot_index_x32 / left_foot_index_z32,
    left_foot_index_y = left_foot_index_y32 / left_foot_index_z32,     
    ## coord 33
    right_foot_index_x = right_foot_index_x33 / right_foot_index_z33,
    right_foot_index_y = right_foot_index_y33 / right_foot_index_z33,
    ######## GET POSE CENTER #########
    hip_center_x = (left_hip_x + right_hip_x) * 0.5,
    hip_center_y = (left_hip_y = right_hip_y) * 0.5,
    shoulder_center_x = (left_shoulder_x + right_shoulder_x) * 0.5,
    shoulder_center_y = (left_shoulder_y + right_shoulder_y) * 0.5,
    torso_size =  sqrt((shoulder_center_x - hip_center_x)**2 + (shoulder_center_x - hip_center_x)**2) * 0.0104166667,
    
    ######## ANGLE CALCULATIONS ################
    ### right elbow - wrist: 3, elbow: 2, shoulder 1##
    right_elbow_angle = rad2deg(atan2(right_wrist_y - right_elbow_y,right_wrist_x - right_elbow_x) - 
                           atan2(right_shoulder_y - right_elbow_y,right_shoulder_x - right_elbow_x)),
    right_elbow_angle = ifelse(right_elbow_angle < 0, right_elbow_angle + 360,right_elbow_angle),
    right_elbow_angle = ifelse(right_elbow_angle > 180,360 - right_elbow_angle,right_elbow_angle),
    ### left elbow ####
    left_elbow_angle = rad2deg(atan2(left_wrist_y - left_elbow_y,left_wrist_x - left_elbow_x) - 
                                  atan2(left_shoulder_y - left_elbow_y,left_shoulder_x - left_elbow_x)),
    left_elbow_angle = ifelse(left_elbow_angle < 0, left_elbow_angle + 360,left_elbow_angle),
    left_elbow_angle = ifelse(left_elbow_angle > 180,360 - left_elbow_angle,left_elbow_angle),
    ### right shoulder ##
    right_shoulder_angle = rad2deg(atan2(right_elbow_y - right_shoulder_y,right_elbow_x - right_shoulder_x) - 
                                  atan2(right_hip_y - right_shoulder_y,right_hip_x - right_shoulder_x)),
    right_shoulder_angle = ifelse(right_shoulder_angle < 0, right_shoulder_angle + 360,right_shoulder_angle),
    right_shoulder_angle = ifelse(right_shoulder_angle > 180,360 - right_shoulder_angle,right_shoulder_angle),
    ### left shoulder
    left_shoulder_angle = rad2deg(atan2(left_elbow_y - left_shoulder_y,left_elbow_x - left_shoulder_x) - 
                                     atan2(left_hip_y - left_shoulder_y,left_hip_x - left_shoulder_x)),
    left_shoulder_angle = ifelse(left_shoulder_angle < 0, left_shoulder_angle + 360,left_shoulder_angle),
    left_shoulder_angle = ifelse(left_shoulder_angle > 180,360 - left_shoulder_angle,left_shoulder_angle),
    ### right knee
    right_knee_angle = rad2deg(atan2(right_hip_y - right_knee_y,right_hip_x - right_knee_x) - 
                                 atan2(right_ankle_y - right_knee_y,right_ankle_x - right_knee_x)),
    right_knee_angle = ifelse(right_knee_angle < 0, right_knee_angle + 360,right_knee_angle),
    right_knee_angle = ifelse(right_knee_angle > 180,360 - right_knee_angle,right_knee_angle),
    #### left knee
    left_knee_angle = rad2deg(atan2(left_hip_y - left_knee_y,left_hip_x - left_knee_x) - 
                                 atan2(left_ankle_y - left_knee_y,left_ankle_x - left_knee_x)),
    left_knee_angle = ifelse(left_knee_angle < 0, left_knee_angle + 360,left_knee_angle),
    left_knee_angle = ifelse(left_knee_angle > 180,360 - left_knee_angle,left_knee_angle),
    ### right hip
    right_hip_angle = rad2deg(atan2(right_shoulder_y - right_hip_y,right_shoulder_x - right_hip_x) - 
                                 atan2(right_knee_y - right_hip_y,right_knee_x - right_hip_x)),
    right_hip_angle = ifelse(right_hip_angle < 0, right_hip_angle + 360,right_hip_angle),
    right_hip_angle = ifelse(right_hip_angle > 180,360 - right_hip_angle,right_hip_angle),
    #### left hip
    left_hip_angle = rad2deg(atan2(left_shoulder_y - left_hip_y,left_shoulder_x - left_hip_x) - 
                                atan2(left_knee_y - left_hip_y,left_knee_x - left_hip_x)),
    left_hip_angle = ifelse(left_hip_angle < 0, left_hip_angle + 360,left_hip_angle),
    left_hip_angle = ifelse(left_hip_angle > 180,360 - left_hip_angle,left_hip_angle),
    ######## DISTANCE CALCULATIONS ###############
    ankle_distance = sqrt((left_ankle_x28 - right_ankle_x29)**2 + (left_ankle_y28 - right_ankle_y29)**2 + (left_ankle_z28 - right_ankle_z29)**2) * 0.0104166667,
    right_arm_distance = sqrt((right_shoulder_x13 - right_index_x21)**2 + (right_shoulder_y13 - right_index_y21)**2 + (right_shoulder_z13 - right_index_z21)**2) * 0.0104166667,
    right_elbow_hip_distance = sqrt((right_elbow_x15 - right_hip_x25)**2 + (right_elbow_y15 - right_hip_y25)**2 + (right_elbow_z15 - right_hip_z25)**2) * 0.0104166667,
    left_arm_distance = sqrt((left_shoulder_x12 - left_index_x20)**2 + (left_shoulder_y12 - left_index_y20)**2 + (left_shoulder_z12 - left_index_z20)**2) * 0.0104166667,
    left_elbow_hip_distance = sqrt((left_elbow_x14 - left_hip_x24)**2 + (left_elbow_y14 - left_hip_y24)**2 + (left_elbow_z14 - left_hip_z24)**2) * 0.0104166667
  ) %>%
  arrange(throw_id,time) %>%
  mutate(
    ############## VELOCITIES #########
    ### left wrist velocity
    left_wrist_velocity = ifelse(throw_id == lag(throw_id),
                                 (sqrt((left_wrist_x16 - lag(left_wrist_x16))**2 + 
                                         (left_wrist_y16 - lag(left_wrist_y16))**2 + 
                                         (left_wrist_z16 - lag(left_wrist_z16))**2) * 0.0104166667) / (time - lag(time)),NA),  ### convert using 96 PPI to inches 
    left_wrist_velocity = ((left_wrist_velocity / 17.6) * 0.44704),  ### convert to MPH to M/S
    avg_left_wrist_velocity = ifelse(throw_id == lag(throw_id),
                                     zoo::rollmean(left_wrist_velocity,round(fps/2,0),align = "right",na.pad = T),NA),  ### utilize half second increment average,
    left_wrist_velocity_i = ifelse(throw_id == lag(throw_id),
                                   lag(left_wrist_velocity,round(15,0)),  ## 15 approximate fps speed
                                   NA),
    time_i = ifelse(throw_id == lag(throw_id),lag(time,15),NA),
    left_wrist_acceleration = (left_wrist_velocity - left_wrist_velocity_i) / (time - time_i),
    ### right wrist velocity
    right_wrist_velocity = ifelse(throw_id == lag(throw_id),
                                  (sqrt((right_wrist_x17 - lag(right_wrist_x17))**2 + 
                                         (right_wrist_y17 - lag(right_wrist_y17))**2 + 
                                         (right_wrist_z17 - lag(right_wrist_z17))**2) * 0.0104166667) / (time - lag(time)),NA),  ### convert using 96 PPI to inches 
    right_wrist_velocity = ((right_wrist_velocity / 17.6) * 0.44704),  ### convert to MPH to M/S
    avg_right_wrist_velocity = ifelse(throw_id == lag(throw_id),
                                      zoo::rollmean(right_wrist_velocity,round(fps/2,0),align = "right",na.pad = T),NA),  ### utilize half second increment average,
    right_wrist_velocity_i = ifelse(throw_id == lag(throw_id),
                                    lag(right_wrist_velocity,round(15,0)),  ## 15 approximate fps speed
                                    NA),
    right_wrist_acceleration = (right_wrist_velocity - right_wrist_velocity_i) / (time - time_i),
    #### left ankle velocity
    left_ankle_velocity = ifelse(throw_id == lag(throw_id),
                                 (sqrt((left_ankle_x28 - lag(left_ankle_x28))**2 + 
                                         (left_ankle_y28 - lag(left_ankle_y28))**2 + 
                                         (left_ankle_z28 - lag(left_ankle_z28))**2) * 0.0104166667) / (time - lag(time)),NA),   ### convert using 96 PPI to inches
    left_ankle_velocity = ((left_ankle_velocity / 17.6) * 0.44704), #covert to MPH and then to M/S
    avg_left_ankle_velocity = ifelse(throw_id == lag(throw_id),
                                     zoo::rollmean(left_ankle_velocity,15,align = "right",na.pad = T),NA),  ### utilize half second increment average,
    left_ankle_velocity_i = ifelse(throw_id == lag(throw_id),
                                   lag(left_ankle_velocity,15),
                                   NA),
    left_ankle_acceleration = (left_ankle_velocity - left_ankle_velocity_i) / (time - time_i) ,
    #### right ankle velocity
    right_ankle_velocity = ifelse(throw_id == lag(throw_id),
                                  (sqrt((right_ankle_x29 - lag(right_ankle_x29))**2 + 
                                         (right_ankle_y29 - lag(right_ankle_y29))**2 + 
                                         (right_ankle_z29 - lag(right_ankle_z29))**2) * 0.0104166667) / (time - lag(time)),NA),   ### convert using 96 PPI to inches
    right_ankle_velocity = ((right_ankle_velocity / 17.6) * 0.44704), #covert to MPH and then to M/S
    avg_right_ankle_velocity = ifelse(throw_id == lag(throw_id),
                                      zoo::rollmean(right_ankle_velocity,15,align = "right",na.pad = T),NA),  ### utilize half second increment average,
    right_ankle_velocity_i = ifelse(throw_id == lag(throw_id),
                                    lag(right_ankle_velocity,15),
                                    NA),
    right_ankle_acceleration = (right_ankle_velocity - right_ankle_velocity_i) / (time - time_i),
    ################## ANGULAR VELOCITY ##################
    right_elbow_angular_velocity = ifelse(throw_id == lag(throw_id),
                                          right_elbow_angle - lag(right_elbow_angle) / (time - lag(time)),NA),
    avg_right_elbow_angular_velocity = ifelse(throw_id == lag(throw_id),
                                              zoo::rollmean(right_elbow_angular_velocity,round(fps/2,0),align = "right",na.pad = T),NA),
    right_shoulder_angular_velocity = ifelse(throw_id == lag(throw_id),
                                             right_shoulder_angle - lag(right_shoulder_angle) / (time - lag(time)),NA),
    avg_right_shoulder_angular_velocity = ifelse(throw_id == lag(throw_id),
                                                 zoo::rollmean(right_shoulder_angular_velocity,round(fps/2,0),align = "right",na.pad = T),NA),
    right_knee_angular_velocity = ifelse(throw_id == lag(throw_id),
                                         right_knee_angle - lag(right_knee_angle) / (time - lag(time)),NA),
    avg_right_knee_angular_velocity = ifelse(throw_id == lag(throw_id),
                                             zoo::rollmean(right_knee_angular_velocity,round(fps/2,0),align = "right",na.pad = T),NA),
    right_hip_angular_velocity = ifelse(throw_id == lag(throw_id),
                                        right_hip_angle - lag(right_hip_angle) / (time - lag(time)),NA),
    avg_right_hip_angular_velocity = ifelse(throw_id == lag(throw_id),
                                            zoo::rollmean(right_hip_angular_velocity,round(fps/2,0),align = "right",na.pad = T),NA),
    ##### SLOPE - calculate vertical or horizontal position ###################
    slope1 = ((right_shoulder_y - right_knee_y)/(right_shoulder_x - right_knee_x)),
    slope2 = ((right_hip_y - right_knee_y) / (right_hip_x - right_knee_x))) %>%
  rowwise() %>%
    mutate(slope = min(slope1,slope2)) %>%
  dplyr::select(-slope1,-slope2) %>%
  ungroup() %>%
  ####### cuts for classification
  mutate(
    rownumber = row_number(),
    time_cut = cut(time,
                          breaks = c(0,0.25,0.5,0.75,1,1.25,1.5,1.75,2,2.25,2.5,2.75,3,3.25,3.5,3.75,4)),
    throw_class = case_when(
      right_elbow_angle >= 0 & right_elbow_angle < 80 & throw_hand == "right" ~ "ball_held",
      right_elbow_angle >= 80 & right_elbow_angle <= 100  & throw_hand == "right" ~ "release",
      right_elbow_angle > 100 & right_elbow_angle < 180 & throw_hand == "right" ~ "windup",
      left_elbow_angle >= 0 & left_elbow_angle < 80 & throw_hand == "left" ~ "ball_held",
      left_elbow_angle >= 80 & left_elbow_angle <= 100  & throw_hand == "left" ~ "release",
      left_elbow_angle > 100 & left_elbow_angle < 180 & throw_hand == "left" ~ "windup",  
      TRUE ~ as.character(NA)
    )
    )
  



#### hip, knee, ankle
throws %>%
  dplyr::group_by(drop) %>%
  dplyr::summarize(n = n_distinct(throw_id))


#### to-do
### calculate angular velocity
### wrist velocity, acceleration to identify how fast someone throws

#### incorporate gait metrics
#### incorporate inverse dyanmics


    

################## EDA #####################

    

throws %>%
  ggplot() +
  aes(x=time,y=right_elbow_angle,color=name) +
  geom_point(alpha=0.5) +
  theme_minimal() +
  theme(
    legend.position  = "none"
  ) 



throws %>%
  ggplot() + 
  aes(x=right_elbow_angle)  +
  geom_density() +
  facet_wrap(~drop)

##### create a target variable? 
## 0 - 80, 80 - 100, 100 - 180

throws %>%
  dplyr::filter(row < 120) %>%  ### first 120 frames
  dplyr::group_by(time) %>%
  dplyr::summarize(right_elbow_angle = median(right_elbow_angle,na.rm = T)) %>%
  ggplot() + 
  aes(x=time,y=right_elbow_angle)  +
  geom_smooth()

#### hit throw around 2 to 2.5 seconds

throws %>%
  ggplot() + 
  aes(x=right_shoulder_angle)  +
  geom_density() +
  facet_wrap(~drop)

### similar trend

throws %>%
  ggplot() +
  aes(x=right_elbow_angle,y=right_knee_angle) +
  geom_jitter() +
  facet_wrap(~drop)

### negative correlation? 


throws %>%
  dplyr::group_by(drop) %>%
  dplyr::summarize(n = n_distinct(throw_id))

### 86 - exlucde 4-5 steps throws?

### comparing throws for first 4 seconds
### look like ball is held tight for first few seconds of drop back
### 4-5 step may be do sample size? 
throws %>%
  dplyr::group_by(time,drop) %>%
  dplyr::filter(time <= 4,
                drop != "4-5 step") %>%
  dplyr::summarize(right_elbow_angle = median(right_elbow_angle,na.rm = T)) %>%
  ggplot() +
  geom_point(aes(x=time,y=right_elbow_angle,color=drop),alpha = 0.3) +
  facet_wrap(~drop,ncol = 1) +
  geom_smooth(aes(x=time,y=right_elbow_angle),color="dark blue",linetype = "dashed") +
  theme_minimal() +
  theme(
    legend.position = "none"
  ) +
  scale_color_brewer(palette = "Dark2") +
  labs(
    title = "Elbow Angle for Throw",
    subtitle = "@QuinnsWisdom",
    x = "Time (Sec)",
    y = "Right Elbow Angle (Degrees)"
  ) 


throws %>%
  dplyr::group_by(time,name,drop) %>%
  dplyr::filter(time <= 4,
                drop != "4-5 step") %>%
  dplyr::summarize(right_elbow_angle = median(right_elbow_angle,na.rm = T)) %>%
  ggplot() +
  geom_point(aes(x=time,y=right_elbow_angle,color=drop),alpha = 0.3) +
  facet_wrap(~drop,ncol = 1) +
  geom_smooth(aes(x=time,y=right_elbow_angle,group=name),color="dark blue",linetype = "dashed") +
  theme_minimal() +
  theme(
    legend.position = "none"
  ) +
  scale_color_brewer(palette = "Dark2") +
  labs(
    title = "Elbow Angle for Throw",
    subtitle = "@QuinnsWisdom",
    x = "Time (Sec)",
    y = "Right Elbow Angle (Degrees)"
  ) 

throws %>%
  dplyr::group_by(time,name,drop) %>%
  dplyr::filter(time <= 4,
                drop != "4-5 step") %>%
  dplyr::summarize(right_wrist_velocity = median(right_wrist_velocity,na.rm = T)) %>%
  ggplot() +
  geom_point(aes(x=time,y=right_wrist_velocity,color=drop),alpha = 0.3) +
  facet_wrap(~drop,ncol = 1) +
  geom_smooth(aes(x=time,y=right_wrist_velocity,group=name),color="dark blue",linetype = "dashed") +
  theme_minimal() +
  theme(
    legend.position = "none"
  ) +
  scale_color_brewer(palette = "Dark2") +
  labs(
    title = "Elbow Angle for Throw",
    subtitle = "@QuinnsWisdom",
    x = "Time (Sec)",
    y = "Right Wrist Velocity (m/s)"
  ) 

#### normal distribution
throws %>%
  ggplot() +
  geom_density(aes(x=right_wrist_acceleration,group=name,color = name))


#### acceleration on two ends of the spectrum
throws %>%
  ggplot() +
  geom_point(aes(x=right_wrist_acceleration,y=right_elbow_angle,group=name,color = name)) +
  theme(
    legend.position = "none"
  )



throws %>%
  dplyr::group_by(throw_id,throw_class) %>%
  dplyr::filter(throw_class == "release") %>%
  dplyr::summarize(n = n()) %>%
  dplyr::arrange(desc(n))

### majority in single digits

throws %>%
  dplyr::group_by(throw_class) %>%
  dplyr::summarize(n = n()) %>%
  dplyr::arrange(desc(n))

##### cluster angles to predict? 
#### model to other variables that effect ball output


#### convert pixels to inches
### using PPI of 96 which approxiamtes for 5 x 3 inch video

#0.0104166667 


############## CONVERT TO UMAP ################
umap_fit<-throws %>%
  dplyr::select(left_shoulder_x,left_shoulder_y,right_shoulder_x,right_shoulder_y,
                left_elbow_x,left_elbow_y,left_wrist_x,left_wrist_y,
                right_wrist_x,right_wrist_y,left_pinky_x,
                left_pinky_y,right_pinky_x,right_pinky_y,
                left_index_x,left_index_y,right_index_x,
                right_index_y,left_thumb_x,left_thumb_y,right_thumb_x,
                right_thumb_y,left_hip_x,left_hip_y,right_hip_x,
                right_hip_y,left_knee_x,left_knee_y,
                right_knee_x,right_knee_y,left_ankle_x,left_ankle_y,right_ankle_x,
                right_ankle_y,left_heel_x,left_heel_y,  
                right_heel_x,right_heel_y,left_foot_index_x,left_foot_index_y,right_foot_index_x,
                right_foot_index_y,right_elbow_angle,right_shoulder_angle,
                right_knee_angle,right_hip_angle,ankle_distance,right_arm_distance,
                right_elbow_hip_distance,left_arm_distance,left_elbow_hip_distance,
                right_wrist_velocity,right_wrist_acceleration,right_ankle_velocity,
                right_elbow_angular_velocity,rownumber) %>%
                drop_na() %>%
                scale() %>%
                umap(n_neighbors = 4,min_dist = 0.1,
                     metric = "manhattan",n_epochs = 200,
                     verbose = TRUE) 


throw_class_df<-throws %>%
  dplyr::select(rownumber,throw_id,name,event,year,throw_number,throw_direction,drop,approx_distance,row,time,throw_class,time_cut,
                right_elbow_angle)


umap_df<-umap_fit$layout %>%
  as.data.frame() %>%
  mutate(rownumber = row_number()) %>%
  left_join(throw_class_df,by = "rownumber")


umap_df %>%
  dplyr::filter(V1 >= -10,    #### outliers
                V2 <= 40) %>%
  ggplot() +
  aes(x = V1,
      y = V2,
      color = drop) +
  geom_point() 

umap_df %>%
  dplyr::filter(V1 >= -10,    #### outliers
                V2 <= 40) %>%
  ggplot() +
  aes(x = V1,
      y = V2,
      color = throw_class) +
  geom_point(alpha=0.5) 





###### MODEL TO TARGET CLASSIFICATION #############
model_data<-throws %>%
  dplyr::select(left_shoulder_x,left_shoulder_y,right_shoulder_x,right_shoulder_y,
                left_elbow_x,left_elbow_y,left_wrist_x,left_wrist_y,
                right_wrist_x,right_wrist_y,left_pinky_x,
                left_pinky_y,right_pinky_x,right_pinky_y,
                left_index_x,left_index_y,right_index_x,
                right_index_y,left_thumb_x,left_thumb_y,right_thumb_x,
                right_thumb_y,left_hip_x,left_hip_y,right_hip_x,
                right_hip_y,left_knee_x,left_knee_y,
                right_knee_x,right_knee_y,left_ankle_x,left_ankle_y,right_ankle_x,
                right_ankle_y,left_heel_x,left_heel_y,  
                right_heel_x,right_heel_y,left_foot_index_x,left_foot_index_y,right_foot_index_x,
                right_foot_index_y,right_elbow_angle,right_shoulder_angle,
                right_knee_angle,right_hip_angle,ankle_distance,right_arm_distance,
                right_elbow_hip_distance,left_arm_distance,left_elbow_hip_distance,
                right_wrist_velocity,right_wrist_acceleration,right_ankle_velocity,
                right_elbow_angular_velocity,torso_size,slope,throw_id,rownumber,throw_class)


split <- initial_split(model_data)

training_set <- training(split) %>% select(-throw_id, -rownumber)
training_set_ids <- training(split) %>% select(throw_id, rownumber)
testing_set <- testing(split) %>% select(-throw_id, -rownumber)
testing_set_ids <- testing(split) %>% select(throw_id, rownumber)



fitControl <- trainControl(## 10-fold CV
  method = "repeatedcv",
  number = 5,
  repeats = 2,
  summaryFunction = multiClassSummary,
  classProbs = TRUE,
  allowParallel = TRUE)

metric<-"ROC"

base_model<-multinom(throw_class ~ .,data=training_set)

summary(base_model)
imp<-varImp(base_model)

######## get rid of x & y coordinates & right elbow angle

model_data<-throws %>%
  dplyr::select(right_shoulder_angle,
                right_knee_angle,right_hip_angle,ankle_distance,right_arm_distance,
                right_elbow_hip_distance,left_arm_distance,left_elbow_hip_distance,
                right_wrist_velocity,right_wrist_acceleration,right_ankle_velocity,
                right_elbow_angular_velocity,torso_size,slope,throw_id,rownumber,throw_class) %>%
  drop_na() 

model_data<-model_data %>%
  mutate(throw_class = as.factor(throw_class))

split <- initial_split(model_data)

training_set <- training(split) %>% select(-throw_id, -rownumber)
training_set_ids <- training(split) %>% select(throw_id, rownumber)
testing_set <- testing(split) %>% select(-throw_id, -rownumber)
testing_set_ids <- testing(split) %>% select(throw_id, rownumber)



revised_base_model<-multinom(throw_class ~ .,data=training_set)

revised_base_model
imp<-varImp(revised_base_model)

testing_set$test_pred<-predict(revised_base_model,newdata = testing_set)

summary(testing_set)

confusionMatrix(data = testing_set$test_pred,testing_set$throw_class,mode = "prec_recall")
postResample(pred = testing_set$test_pred,obs = testing_set$throw_class)
########## how to deal with class imbalance? ####



gbm_model<-train(throw_class ~ .,data = training_set,
                 method = "gbm",
                 trControl = fitControl,
                 verbose = TRUE)

testing_set$test_pred_gbm<-predict(gbm_model,newdata = testing_set)
confusionMatrix(data = testing_set$test_pred_gbm,testing_set$throw_class,mode = "prec_recall")
postResample(pred = testing_set$test_pred_gbm,obs = testing_set$throw_class)



##### add class weights ########3
model_weights<- ifelse(training_set$throw_class == "release",
                       (1/table(training_set$throw_class)[2]) * 0.34,
                ifelse(training_set$throw_class == "ball_held",
                       (1/table(training_set$throw_class)[1]) * 0.33,
                       (1/table(training_set$throw_class)[3]) * 0.33))

fitControl$seeds<-gbm_model$control$seeds

weighted_gbm_fit<-train(throw_class ~ .,
                        data = training_set,
                        method = "gbm",
                        weights = model_weights,
                        metric = "ROC",
                        trControl = fitControl)

testing_set$test_pred_gbm_weight<-predict(weighted_gbm_fit,newdata = testing_set)
confusionMatrix(data = testing_set$test_pred_gbm_weight,testing_set$throw_class,mode = "prec_recall")

#### increased F1 for release class

###### test for down-sampling
fitControl$sampling<-"down"

down_gbm_fit<-train(throw_class ~.,
                    data = training_set,
                    method = "gbm",
                    verbose = FALSE,
                    metric = "ROC",
                    trControl = fitControl)

testing_set$test_pred_gbm_down<-predict(down_gbm_fit,newdata = testing_set)
confusionMatrix(data = testing_set$test_pred_gbm_down,testing_set$throw_class,mode = "prec_recall")

### decrease F1 for release class



