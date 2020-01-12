# Car driver injuries, gender, and seatbelts

## Context

A 2011 [publication](https://ajph.aphapublications.org/doi/pdf/10.2105/AJPH.2011.300275) reports that "The odds for a belt-restrained female driver to sustain severe injuries were 47% (95% confidence interval = 28%, 70%) higher than those for a belt-restrained male driver involved in a comparable crash." This has been reported e.g. as "women were 47 percent more likely to suffer severe injuries" [here](https://www.nytimes.com/2011/11/01/health/research/women-at-greater-risk-of-injury-in-car-crashes-study-finds.html).

Can we find the same phenomenon in data for the UK?

## Data

To compare UK data with these results, we use [Stats19 data](https://data.gov.uk/dataset/cb7ae6f0-4be6-4935-9277-47e5ce24a11f/road-safety-data), the police records of road-traffic collisions. Specifically, we count drivers involved in collisions between years 2013 and 2017. These drivers might have been killed, seriously or slightly injured, or unharmed in the collision. NB: unharmed drivers are only included in the dataset if another person in the collision was injured.

There are 776,480 individuals involved in 502,387 incidents.

Although Stats19 has a 'seat belt in use' covariate in the Casualties dataset, it is considered sensitive data under GDPR. So we use data reported [here](http://www.pacts.org.uk/wp-content/uploads/sites/2/Final-Full-Web-Version-16.05.2019.pdf) to divide reported casualties between belted and unbelted. That is, 25% for male fatalities, 14.8% for female fatalities, 13.7% for male serious injuries, and 6.7% for female serious injuries. For slight injuries, we know only that the overall rate is 4%. So we estimate 5% for male slight injuries, which leaves 2.86% for female slight injuries. Finally, we have no information on uninjured parties so we estimate 2% for both genders, which is slightly higher than the general population (1.4%) and slightly lower than the rates among those slightly injured.

# Results

## gender, belted

These are the total imputed numbers in our dataset for drivers wearing seatbelts involved in collisions:

| Severity | Male | Female |
| --- | --- | --- |
| Fatal | 1550 | 564 |
| Serious | 15126 | 9579 |
| Slight | 172926 | 155208 |
| None | 233779 | 107413 |
| Total | 425766 | 273861 |

And in terms of percentages these are:

| Severity | Male | Female |
| --- | --- | --- |
| Fatal | 0.37 | 0.21 |
| Serious | 3.57 | 3.51 |
| Slight | 40.84 | 56.90 |
| None | 55.22 | 39.40 |


Of male drivers involved in collisions, 0.37% are fatally injured and 3.57% seriously injured. Of female drivers involved in collisions, 0.21% are fatally injured and 3.51% are seriously injured.

The values are similar in magnitude to those of the the US data.
However, in the UK there is a clear propensity for male drivers to be more severely injured and we note that we expect that we are missing many collisions in which no one was injured and some events in which someone was slightly injured so we expect that the true values are lower than those reported.

In the US, it was observed that female drivers were more likely to be fatally injured (mean values 0.33 vs 0.29) and more likely to be seriously injured when correcting for other covariates (the raw values were 3.32% and 3.82%).

What could the reasons be? Differences between cars in the UK and the US? Differences of behaviours in the UK and the US?

## by speed limit

The US study accounted for the speed differential before and after the collision. We don't have that information for the UK data, but we do have the speed limit. The greater probability for male drivers to suffer fatality injury does not waver across different speed limits. There is more overlap for serious injuries.

Percent fatalities at different speed limits:

| Speed limit, mph | Male | Female |
| --- | --- | --- |
| 20 | 0.13 | 0.03 |
| 30 | 0.15 | 0.05 |
| 40 | 0.45 | 0.19 |
| 50 | 0.80 | 0.40 |
| 60 | 1.45 | 0.85 |
| 70 | 0.76 | 0.37 |

Percent serious injuries at different speed limits:

| Speed limit, mph | Male | Female |
| --- | --- | --- |
| 20 | 1.76 | 1.86 |
| 30 | 2.29 | 2.08 |
| 40 | 4.13 | 3.83 |
| 50 | 5.68 | 5.39 |
| 60 | 9.31 | 8.27 |
| 70 | 4.86 | 4.90 |

## belted vs unbelted

These are the total imputed numbers in our dataset for drivers not wearing seatbelts involved in collisions:

| Severity | Male | Female |
| --- | --- | --- |
| Fatal | 539 | 98 |
| Serious | 2404 | 689 |
| Slight | 9101 | 4570 |
| None | 4771 | 2192 |
| Total | 16815 | 7550 |

And in terms of percentages these are:

| Severity | Male | Female |
| --- | --- | --- |
| Fatal | 3.21 | 1.30 |
| Serious | 14.30 | 9.13 |
| Slight | 54.13 | 60.54 |
| None | 28.37 | 29.03 |

Dividing this table by its belted counterpart, we get the odds ratio: how much more likely an unbelted person is to suffer injury relative to a belted person:

| Severity | Male | Female |
| --- | --- | --- |
| Fatal | 8.75 | 6.28 |
| Serious | 4.00 | 2.60 |
| Slight | 1.33 | 1.06 |
| None | 0.51 | 0.74 |

Drivers not wearing seatbelts are 8.6 times more likely to be fatally injured on collision. For male drivers, it's 8.75 times, and for female drivers it's 6.28 times.

This might be because all drivers are equally likely (3%, compared to 1.4% [here](pacts.org.uk/wp-content/uploads/sites/2/Final-Full-Web-Version-16.05.2019.pdf)) to not be wearing a seatbelt and a seatbelt makes you 8.6 times less likely to die when you collide, or because drivers not wearing seatbelts are 8.6 times more likely to be involved in a fatal collision, or a combination of these two things. At this point we can't separate the two effects to learn how causal each factor is.

## gender by belt

By taking the ratio of the odds ratio, we see the differential effect of seatbelt wearing between male drivers and female drivers. The ratios are 1.40 for fatalities, 1.54 for serious injuries, 1.25 for slight injuries, and 0.70 for no injuries.

Again, there are two possible interpretations that could explain the observation, and the reality is likely a combination of the two.
1) If male and female seatbelt wearers and nonwearers have the same propensity to have fatal collisions, then seatbelts protect male drivers 40% better than they do female drivers.
2) If seatbelts protect male and female drivers the same, then unbelted male drivers are 40% more likely to become involved  in fatal collisions than unbelted female drivers relative to their belted counterparts.

----

## the gender difference

What explains the gender difference? Consistently male drivers are fatally injured at a higher rate than female drivers, whether seatbelts are worn or not. Why?

### differing rates of interaction

Considering only collisions between exactly two cars, where the drivers were either male or female, we have 143,732 crashes, involving 170,080 male drivers and 117,384 female drivers.

With these rates, we expect to see collisions with the following pattern: 35.0% with two male drivers, 16.7% with two female drivers, and 48.3% involving one male driver and one female driver. This is what is seen in the dataset, up to the nearest %: we observe 35.4% with two male drivers, 17.1% with two female drivers, and 47.6% involving one male driver and one female driver. That is, there is a slight over-representation of same-gender crashes, making these two profiles inconsistent.

Out of the 143,732 crashes, there were 749 fatalities. Male drivers were fatally injured at a rate of 0.31%. Female drivers were fatally injured at a rate of 0.19%. A chi-squared test suggests that these rates are not independent of gender.

Once we consider the fatalities alone, the tabulated 'who hit whom' matrix is consistent with equal mixing. We observe

|  | Male fatality | Female fatality |
| --- | --- | --- |
| Male driver involved in fatality of other | 528 | 221 |
| Female driver involved in fatality of other | 545 | 204 |

So it seems that unequal mixing is not sufficient to explain the different fatality rates between male and female drivers.

Indeed, the rates of fatality persist in their difference even when there is no other vehicle involved in the collision:

| Speed limit, mph | Male | Female |
| --- | --- | --- |
| 20 | 1.06 | 0.53 |
| 30 | 1.46 | 0.74 |
| 40 | 3.30 | 1.61 |
| 50 | 3.70 | 1.40 |
| 60 | 3.05 | 1.35 |
| 70 | 3.54 | 1.51 |

### reporting rate

We might assume that slight injuries are under-reported for male drivers, meaning we are missing a substantial portion of the denomiator for male drivers. The Stats19 dataset records whether or not the vehicle skidded or overturned. If these crashes (those in which the car overturned) are more likely to be reported (as an insurance claim might be more likely), we would expect to see less of an under-reporting bias. However, the pattern persists, at all speed limits:

| Speed limit, mph | Male | Female |
| --- | --- | --- |
| 20 | 1.74 | 0.00 |
| 30 | 1.80 | 0.91 |
| 40 | 2.96 | 1.46 |
| 50 | 3.61 | 1.43 |
| 60 | 3.08 | 1.55 |
| 70 | 3.32 | 1.70 |

---

### data we have but haven't used:
- first point of impact, age, what the car collided with
### data we haven't used because we don't have:
- type of injury, number of car rolls, velocity differential, bmi, car age, car type
