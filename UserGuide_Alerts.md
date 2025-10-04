# User Guide - Grafana Alerts

## Prerequisites

- Grafana login with Alerting permissions.  
- At least one dashboard panel with a working query.  
- An email or chat destination for notifications.  
- Clear thresholds agreed with your team/stakeholders (avoid guesswork).

---

## Key Concepts

- **Alert rule:** The check that runs on a schedule.  
- **Condition:** Logic that decides OK vs Alerting.  
- **For:** How long the breach must persist before alerting.  
- **Labels:** Tags like `country=Mozambique`, `indicator=NDVI`.  
- **Annotations:** Human‑readable context in notifications.  
- **Contact point:** Where to send alerts (email, Slack, Teams).  
- **Notification policy:** Routing rules, grouping, quiet hours.  
- **Silence / Mute timing:** Temporary pause to reduce noise.

---

## Quick start (10 minutes)

1. Create a **Contact point** (email).  
2. Set a **Notification policy** to route alerts.  
3. Create an **Alert rule** from a dashboard panel.  
4. Test with **Preview**. Save.  
5. Trigger a dummy breach if possible. Confirm delivery.  
6. Add a **Silence** for maintenance windows.

---

## Create a Contact point

1. Go to **Alerting → Contact points**.  
2. Select **+ Create contact point**.  
3. Name it clearly, e.g., `FoodSec‑Ops‑Email`.  
4. Choose **Email**. Enter recipient, multiple recipients can be entered using ';' or ','.
    i. Slack/Teams notifications could also be used. This requires webhooks, so if you're unfamiliar, seek guidance from your IT team.  
5. Click **Test** to confirm delivery.  
    i. If the test fails to deliver, confirm your SMTP settings are correct, and double-check you've restarted your Grafana service.
6. In **Optional email settings**, the default messages and subjects can be edited or new ones can be created.
    i. [Follow the tutorial here](https://grafana.com/tutorials/alerting-get-started-pt4/) if you're interested in customising alerts.
7. Click **Save contact point**.

---

## Route notifications with a Policy

1. Go to **Alerting → Notification policies**.
2. There will be a default policy. Click **More** -> **Edit** and update as needed.
3. Click **+ New child policy** to have subsequent notification policies inherit the settings of the default.  
4. **Matching labels:** e.g., `country=Mozambique`.  
    i. Add more **matchers** if required.
5. **Contact point:** select the contact point created earlier.  
6. **Override grouping:** e.g., by `country, indicator`.  
7. **Override general timings:** 5m. **Group interval:** 30m. **Repeat:** 2d.  
8. Optional quiet hours: **Mute timings** → add local hours.  
9. **Update policy**.

---

## Create an Alert from a Dashboard Panel

1. Open the dashboard.  
2. Hover the panel -> **⋮** -> **More** -> **New alert rule**.  
3. **Alert name:** make it concise and scannable, e.g., `UA | NDVI below 0.2 for 3h`.  
4. **Define query and alert condition:** The query used to produce the dashboard widget will be displayed. Add a meaningful alert condition for when the alert should fire.
5. **Add folders and labels:** e.g., `country=Ukraine`, `indicator=NDVI`, `severity=high`.  
6. **Evaluation group and interval:** Select existing groups if you have any, or create a new one to save the settings to.
7. **Pending period:** <15m for fast data, 1h for slow data.  
8. **Keep firing for:** set persistence, e.g., `30m` to filter spikes.  
9. **Configure notifications:** add the contact point that should be utilised.  
10. **Configure notification message:** Enter a custom summary and  description for the alert.  
11. Choose **Folder** and **Save**.

---

## Create an Alert from Scratch

WIP; getting an error trying to save from the previous instructions so will need to sort that out
err: "[sse.readDataError] [A] got error: input data must be a wide series but got type long (input refid)"

---

## Governance and security

- Least privilege access to Alerting.  
- No PII in labels. Keep labels generic.  
- Use folders per environment: `prod`, `staging`.  
- Review delivery logs weekly.

---

## Troubleshooting

- **No notifications:** test the contact point. Check policy match.  
- **Rule never fires:** query returns no data or wrong condition. Use Preview.  
- **Too many alerts:** increase **Keep firing for**, add grouping, set mute timings.  
- **Time zone issues:** verify dashboard and policy time zones.  
- **Duplicate alerts in multiple channels:** consolidate contact points or adjust routing.

---

## Appendix: Glossary

- **NDVI:** Normalized Difference Vegetation Index.  
