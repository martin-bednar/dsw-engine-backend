module Shared.Database.Migration.Development.Template.Data.DefaultTemplate where

import Text.RawString.QQ

html :: String
html =
  [r|<!DOCTYPE HTML>
{# ------------------------------------------------------------------------------------ #}
{#  VARIABLES                                                                           #}
{# ------------------------------------------------------------------------------------ #}
{%- set km = ctx.knowledgeModel -%}
{%- set replies = ctx.questionnaireReplies -%}
{%- set repliesMap = ctx.questionnaireRepliesMap -%}
{%- set report = ctx.report -%}
{%- set metricDefinitions = ctx.metrics -%}
{%- set levelDefinitions = ctx.levels -%}
{# ------------------------------------------------------------------------------------ #}
{#  TAGS, REFERNCES, and EXPERTS MACROS                                                 #}
{# ------------------------------------------------------------------------------------ #}
{%- macro renderTags(tagUuids) -%}
  {% if tagUuids|length > 0 %}
    <div class="tags">
      <?xml version="1.0" encoding="UTF-8" standalone="no"?><svg xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:cc="http://creativecommons.org/ns#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:svg="http://www.w3.org/2000/svg" xmlns="http://www.w3.org/2000/svg" xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd" xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape" viewBox="0 -256 1950 1950" id="svg4303" version="1.1" inkscape:version="0.48.3.1 r9886" width="100%" height="100%" sodipodi:docname="tags_font_awesome.svg"><defs id="defs4311" /><sodipodi:namedview pagecolor="#ffffff" bordercolor="#666666" borderopacity="1" objecttolerance="10" gridtolerance="10" guidetolerance="10" inkscape:pageopacity="0" inkscape:pageshadow="2" inkscape:window-width="640" inkscape:window-height="480" id="namedview4309" showgrid="false" inkscape:zoom="0.52187927" inkscape:cx="9.5432149" inkscape:cy="1022.7118" inkscape:window-x="0" inkscape:window-y="25" inkscape:window-maximized="0" inkscape:current-layer="svg4303" /><g transform="matrix(1,0,0,-1,21.678786,1392.819)" id="g4305"><path d="m 448,1088 q 0,53 -37.5,90.5 Q 373,1216 320,1216 267,1216 229.5,1178.5 192,1141 192,1088 192,1035 229.5,997.5 267,960 320,960 q 53,0 90.5,37.5 Q 448,1035 448,1088 z M 1515,512 q 0,-53 -37,-90 L 987,-70 q -39,-37 -91,-37 -53,0 -90,37 L 91,646 Q 53,683 26.5,747 0,811 0,864 v 416 q 0,52 38,90 38,38 90,38 h 416 q 53,0 117,-26.5 64,-26.5 102,-64.5 l 715,-714 q 37,-39 37,-91 z m 384,0 q 0,-53 -37,-90 L 1371,-70 q -39,-37 -91,-37 -36,0 -59,14 -23,14 -53,45 l 470,470 q 37,37 37,90 0,52 -37,91 l -715,714 q -38,38 -102,64.5 -64,26.5 -117,26.5 h 224 q 53,0 117,-26.5 64,-26.5 102,-64.5 l 715,-714 q 37,-39 37,-91 z" id="path4307" inkscape:connector-curvature="0" style="fill:currentColor" /></g></svg>
      <b>Tags:</b>
      {% for tagUuid in tagUuids %}
        {% set tag = km.entities.tags[tagUuid] %}
        <i class="tag">{{tag.name}}</i>
      {% endfor %}
    </div>
  {% endif %}
{%- endmacro -%}
{%- macro renderResourcePageReferences(referenceUuids) -%}
  {% set resourcePageReferences = [] %}
  {% for uuid in referenceUuids %}
    {% if km.entities.references[uuid].referenceType == "ResourcePageReference" %}
      {% do resourcePageReferences.append(km.entities.references[uuid]) %}
    {% endif %}
  {% endfor %}
  {% if resourcePageReferences|length > 0 %}
    <div class="references references-resourcepage">
      <svg aria-hidden="true" data-prefix="fas" data-icon="book" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" class="svg-inline--fa fa-book fa-w-14 fa-2x"><path fill="currentColor" d="M448 360V24c0-13.3-10.7-24-24-24H96C43 0 0 43 0 96v320c0 53 43 96 96 96h328c13.3 0 24-10.7 24-24v-16c0-7.5-3.5-14.3-8.9-18.7-4.2-15.4-4.2-59.3 0-74.7 5.4-4.3 8.9-11.1 8.9-18.6zM128 134c0-3.3 2.7-6 6-6h212c3.3 0 6 2.7 6 6v20c0 3.3-2.7 6-6 6H134c-3.3 0-6-2.7-6-6v-20zm0 64c0-3.3 2.7-6 6-6h212c3.3 0 6 2.7 6 6v20c0 3.3-2.7 6-6 6H134c-3.3 0-6-2.7-6-6v-20zm253.4 250H96c-17.7 0-32-14.3-32-32 0-17.6 14.4-32 32-32h285.4c-1.9 17.1-1.9 46.9 0 64z" class=""></path></svg>
      <span><b>Data Stewardship for Open Science:</b></span>
      {% for reference in resourcePageReferences %}
        {% if reference.referenceType == "ResourcePageReference" %}
          <a id="{{reference.uuid}}" class="reference resourcepage-link" href="{{ ("https://demo.ds-wizard.org/book-references/" ~ reference.shortUuid) }}" target="_blank"><i>{{reference.shortUuid}}</i></a>
        {% endif %}
      {% endfor %}
    </div>
  {% endif %}
{%- endmacro -%}
{%- macro renderURLReferences(referenceUuids) -%}
  {% set urlReferences = [] %}
  {% for uuid in referenceUuids %}
    {% if km.entities.references[uuid].referenceType == "URLReference" %}
      {% do urlReferences.append(km.entities.references[uuid]) %}
    {% endif %}
  {% endfor %}
  {% if urlReferences|length > 0 %}
    <div class="references references-url" >
      <svg aria-hidden="true" data-prefix="far" data-icon="external-link" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 576 512" class="svg-inline--fa fa-external-link fa-w-18 fa-2x"><path fill="currentColor" d="M576 14.4l-.174 163.2c0 7.953-6.447 14.4-14.4 14.4H528.12c-8.067 0-14.56-6.626-14.397-14.691l2.717-73.627-2.062-2.062-278.863 278.865c-4.686 4.686-12.284 4.686-16.971 0l-23.029-23.029c-4.686-4.686-4.686-12.284 0-16.971L474.379 61.621l-2.062-2.062-73.626 2.717C390.626 62.44 384 55.946 384 47.879V14.574c0-7.953 6.447-14.4 14.4-14.4L561.6 0c7.953 0 14.4 6.447 14.4 14.4zM427.515 233.74l-24 24a12.002 12.002 0 0 0-3.515 8.485V458a6 6 0 0 1-6 6H54a6 6 0 0 1-6-6V118a6 6 0 0 1 6-6h301.976c10.691 0 16.045-12.926 8.485-20.485l-24-24A12.002 12.002 0 0 0 331.976 64H48C21.49 64 0 85.49 0 112v352c0 26.51 21.49 48 48 48h352c26.51 0 48-21.49 48-48V242.225c0-10.691-12.926-16.045-20.485-8.485z" class=""></path></svg>
      <b>External Links:</b>
      {% for reference in urlReferences %}
        {% if reference.referenceType == "URLReference" %}
          <a id="{{reference.uuid}}" class="reference url-link" href="{{reference.url}}" target="_blank"><i>{{reference.aLabel}}</i></a>
        {% endif %}
      {% endfor %}
    </div>
  {% endif %}
{%- endmacro -%}
{%- macro renderExperts(expertUuids) -%}
  {% if expertUuids|length > 0 %}
    <div class="experts">
      <svg aria-hidden="true" data-prefix="far" data-icon="address-book" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512" class="svg-inline--fa fa-address-book fa-w-14 fa-2x"><path fill="currentColor" d="M436 160c6.6 0 12-5.4 12-12v-40c0-6.6-5.4-12-12-12h-20V48c0-26.5-21.5-48-48-48H48C21.5 0 0 21.5 0 48v416c0 26.5 21.5 48 48 48h320c26.5 0 48-21.5 48-48v-48h20c6.6 0 12-5.4 12-12v-40c0-6.6-5.4-12-12-12h-20v-64h20c6.6 0 12-5.4 12-12v-40c0-6.6-5.4-12-12-12h-20v-64h20zm-68 304H48V48h320v416zM208 256c35.3 0 64-28.7 64-64s-28.7-64-64-64-64 28.7-64 64 28.7 64 64 64zm-89.6 128h179.2c12.4 0 22.4-8.6 22.4-19.2v-19.2c0-31.8-30.1-57.6-67.2-57.6-10.8 0-18.7 8-44.8 8-26.9 0-33.4-8-44.8-8-37.1 0-67.2 25.8-67.2 57.6v19.2c0 10.6 10 19.2 22.4 19.2z" class=""></path></svg>
      <b>Experts:</b>
      {% for expertUuid in expertUuids %}
        {% set expert = km.entities.experts[expertUuid] %}
        <i class="expert">{{expert.name}} (<a href="mailto:{{expert.email}}">{{expert.email}}</a>)</i>
      {% endfor %}
    </div>
  {% endif %}
{%- endmacro -%}
{# ------------------------------------------------------------------------------------ #}
{#  ANSWERS MACROS                                                                      #}
{# ------------------------------------------------------------------------------------ #}
{%- macro renderAnswerValue(question, reply, path, humanIdentifier) -%}
  <div class="answer-block answer-simple" id="{{path}}" data-path="{{reply.path}}" data-type="answer">
    <p class="answer">
      <svg aria-hidden="true" data-prefix="fas" data-icon="check" class="svg-inline--fa fa-check fa-w-16" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><path fill="currentColor" d="M173.898 439.404l-166.4-166.4c-9.997-9.997-9.997-26.206 0-36.204l36.203-36.204c9.997-9.998 26.207-9.998 36.204 0L192 312.69 432.095 72.596c9.997-9.997 26.207-9.997 36.204 0l36.203 36.204c9.997 9.997 9.997 26.206 0 36.204l-294.4 294.401c-9.998 9.997-26.207 9.997-36.204-.001z"></path></svg>
      {% if reply.value.type == "StringReply" %}
        <span>{{reply.value.value}}</span>
      {% else %}
        <span>{{reply.value.value.value}}</span>
        {% if reply.value.value.type == "IntegrationType" and reply.value.value.id %}
          {# Integration #}
          {% set integration = km.entities.integrations[question.integrationUuid] %}
          <div class="integration-link">
            {% if integration.logo %}<img src="{{ integration.logo }}" alt="{{ integration.name }}">{% endif %}
            <a href="{{ integration.itemUrl|replace('${id}', reply.value.value.id) }}">
              {{ integration.itemUrl|replace("${id}", reply.value.value.id) }}
            </a>
          </div>
        {% endif %}
      {% endif %}
    </p>
  </div>
{%- endmacro -%}
{%- macro renderAnswerOption(question, reply, path, humanIdentifier) -%}
  {% set hi = question.answerUuids.index(reply.value.value) %}
  {% set answer = km.entities.answers[reply.value.value] %}
  {% set path = path ~ "." ~ answer.uuid %}
  {% set humanIdentifier = humanIdentifier ~ "." ~ hi|of_alphabet %}
  <div class="answer-block answer-option" id="{{path}}" data-path="{{reply.path}}" data-uuid="{{answer.uuid}}" data-type="answer">
    <p class="answer">
      <svg aria-hidden="true" data-prefix="fas" data-icon="check" class="svg-inline--fa fa-check fa-w-16" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><path fill="currentColor" d="M173.898 439.404l-166.4-166.4c-9.997-9.997-9.997-26.206 0-36.204l36.203-36.204c9.997-9.998 26.207-9.998 36.204 0L192 312.69 432.095 72.596c9.997-9.997 26.207-9.997 36.204 0l36.203 36.204c9.997 9.997 9.997 26.206 0 36.204l-294.4 294.401c-9.998 9.997-26.207 9.997-36.204-.001z"></path></svg>
      <span>{{ hi|of_alphabet }}. {{answer.aLabel}}</span>
    </p>
    {% if answer.advice %}
      <p class="text-muted"><i>{{answer.advice|markdown}}</i></p>
    {% endif %}
    <div class="followups">
      {% set hiPrefix = humanIdentifier ~ "." %}
      {% for questionUuid in answer.followUpUuids %}
        {% set x = loop.index %}
        {{ renderQuestion(km.entities.questions[questionUuid], path, hiPrefix ~ x) }}
      {% endfor %}
    </div>
  </div>
{%- endmacro -%}
{%- macro renderAnswerList(question, reply, path, humanIdentifier) -%}
  <div class="answer-block answer-items" id="{{path}}" data-path="{{reply.path}}" data-type="answer">
    <h4>Answers</h4>
    {% set itemPathPrefix = path ~ "." %}
    {% set hiPrefix = humanIdentifier ~ "." %}
    {% for i in range(0, reply.value.value) %}
      {% set itemPath = itemPathPrefix ~ i %}
      {% set itemHumanIdenfifier = hiPrefix ~ i|of_alphabet %}
      <div class="answer-item" id="{{reply.path}}-{{reply.value.value}}">
        <div class="followups">
          {% for questionUuid in question.itemTemplateQuestionUuids %}
            {% set x = loop.index %}
            {{ renderQuestion(km.entities.questions[questionUuid], itemPath, itemHumanIdenfifier ~ "." ~ x) }}
          {% else %}
            No follow up questions
          {% endfor %}
        </div>
      </div>
    {% else %}
      No answer items
    {% endfor %}
  </div>
{%- endmacro -%}
{# ------------------------------------------------------------------------------------ #}
{#  QUESTION MACROS                                                                     #}
{# ------------------------------------------------------------------------------------ #}
{%- macro questionClasses(question) -%}
  "question {{ "required" if (question.requiredPhaseUuid and question.requiredPhaseUuid <= ctx.level) else "optional"}} {{  ("phase-" ~ question.requiredPhaseUuid) if question.requiredPhaseUuid else "phase-none" }}"
{%- endmacro -%}
{%- macro renderQuestionExtras(question) -%}
  <div class="extra-data">
    {# Question - Tags #}
    {{ renderTags(question.tagUuids) }}
    {# Question - References - Resource Page References #}
    {{ renderResourcePageReferences(question.referenceUuids) }}
    {# Question - References - URL References #}
    {{ renderURLReferences(question.referenceUuids) }}
    {# Question - Experts #}
    {{ renderExperts(question.expertUuids) }}
  </div>
{%- endmacro -%}
{%- macro renderQuestionReply(question, path, humanIdentifier) -%}
  {# Question - Answers #}
  {% set reply = repliesMap[path] %}
  {% if reply %}
    {% if question.questionType == "ValueQuestion" and reply.value.type == "StringReply" %}
      {{ renderAnswerValue(question, reply, path, humanIdentifier) }}
    {% elif question.questionType == "OptionsQuestion" and reply.value.type == "AnswerReply" %}
      {{ renderAnswerOption(question, reply, path, humanIdentifier) }}
    {% elif question.questionType == "ListQuestion" and reply.value.type == "ItemListReply" %}
      {{ renderAnswerList(question, reply, path, humanIdentifier) }}
    {% elif question.questionType == "IntegrationQuestion" and reply.value.type == "IntegrationReply" %}
      {{ renderAnswerValue(question, reply, path, humanIdentifier) }}
    {% endif %}
  {% else %}
    <div class="answer-block not-answered">
      <p class="no-answer">
        <svg aria-hidden="true" data-prefix="fas" data-icon="times" class="svg-inline--fa fa-times fa-w-11" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 352 512"><path fill="currentColor" d="M242.72 256l100.07-100.07c12.28-12.28 12.28-32.19 0-44.48l-22.24-22.24c-12.28-12.28-32.19-12.28-44.48 0L176 189.28 75.93 89.21c-12.28-12.28-32.19-12.28-44.48 0L9.21 111.45c-12.28 12.28-12.28 32.19 0 44.48L109.28 256 9.21 356.07c-12.28 12.28-12.28 32.19 0 44.48l22.24 22.24c12.28 12.28 32.2 12.28 44.48 0L176 322.72l100.07 100.07c12.28 12.28 32.2 12.28 44.48 0l22.24-22.24c12.28-12.28 12.28-32.19 0-44.48L242.72 256z"></path></svg>
        <span>This question has not been answered yet!</span>
      </p>
    </div>
  {% endif %}
{%- endmacro -%}
{%- macro renderQuestion(question, path, humanIdentifier) -%}
  {% set path = path ~ "." ~ question.uuid %}
  <div class={{questionClasses(question)}} id="{{path}}" data-uuid="{{question.uuid}}" data-type="question">
    <h4 class="title">
      <strong class="human-identifier">{{humanIdentifier}}</strong>
      {{question.title}}
    </h4>
    <p class="text text-light">{{question.text|markdown}}</p>

    {{ renderQuestionExtras(question) }}

    {{ renderQuestionReply(question, path, humanIdentifier) }}
  </div>
{%- endmacro -%}
{# ------------------------------------------------------------------------------------ #}
{#  CHAPTER MACROS                                                                      #}
{# ------------------------------------------------------------------------------------ #}

{%- macro renderChapterReport(chapter) -%}
  <section class="report">
    <h3 class="title">Report</h3>

    <h4>Indications</h4>
    <div class="indications">
      <table>
        <tbody>
          {% for chapterReport in report.chapterReports %}
            {% if chapterReport.chapterUuid == chapter.uuid %}
              {% for indication in chapterReport.indications %}
                <tr>
                  <td>Answered {% if indication.indicationType == "PhasesAnsweredIndication" %}(current phase){% endif %}</td>
                  <td>{{indication.answeredQuestions}} / {{indication.answeredQuestions + indication.unansweredQuestions}} </td>
                </tr>
              {% endfor %}
            {% endif %}
          {% endfor %}
        </tbody>
      </table>
    </div>

    <h4>Metrics</h4>
    <div class="metrics">
      {% set chapterReports = report.chapterReports|selectattr("chapterUuid", "equalto", chapter.uuid)|selectattr("metrics", "not_empty")|list %}
      {% if chapterReports|length > 0 %}
        <table>
          <thead><tr><th>Metric</th><th>Score</th></tr></thead>
          <tbody>
            {% for chapterReport in chapterReports %}
              {% if chapterReport.chapterUuid == chapter.uuid %}
                {% for metric in chapterReport.metrics %}
                  <tr>
                    <td>
                      {% for metricDefinition in metricDefinitions %}
                        {% if metric.metricUuid == metricDefinition.uuid %}
                          {{metricDefinition.title}}
                        {% endif %}
                      {% endfor %}
                    </td>
                    <td>{{ metric.measure|round(2) }}</td>
                  </tr>
                {% endfor %}
              {% endif %}
            {% else %}
              No indications
            {% endfor %}
          </tbody>
        </table>
      {% else %}
        <p class="text-light">No metrics for this chapter.</p>
      {% endif %}
    </div>
  </section>
{%- endmacro -%}
{%- macro renderChapter(chapter, humanIdentifier) -%}
      <section class="chapter" id="{{chapter.uuid}}" data-uuid="{{chapter.uuid}}" data-type="chapter">
        <h2 class="title">{{humanIdentifier|roman}}. {{chapter.title}}</h2>
        <p class="text-light">{{chapter.text|markdown}}</p>

        {{ renderChapterReport(chapter) }}

        <section class="questions">
          <h3 class="title">Questions</h3>
          {% for questionUuid in chapter.questionUuids %}
            {{ renderQuestion(km.entities.questions[questionUuid], chapter.uuid, loop.index) }}
          {% else %}
            <p class="text-light">No questions</p>
          {% endfor %}
        </section>
      </section>
{%- endmacro -%}
{# ------------------------------------------------------------------------------------ #}
{#  HTML LAYOUT                                                                         #}
{# ------------------------------------------------------------------------------------ #}
{%- macro renderHeader() -%}
  <header>
    <h1>
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 204 153"><path d="M151,113.37,137.24,89.08l-24.67-7.25,19-2.76L113.81,47.7,95.94,37.89l17.18,2.85,37.53,5.7L94.59,1.33c-2.76-2.67-6.88-1.47-8.32,2.44l-14.4,55,20,3.36L69.71,67,57.32,114.31l36.85,5.2-41.56,6.63L.66,152.1s34.15-1.54,45.76-3.16c44-6.14,76.34-6.76,120.36-13.54,7.71-1.19,37.56-20.62,37.56-20.62Z" style="fill:#333"/></svg>
      <div class="headline">
        <span class="questionnaire-name">{{ctx.questionnaireName}}</span><br>
        <span class="km-name">{{km.name}}</span>
      </div>
    </h1>
    <table class="dmp-data">
      <tr>
        <th>Organization</th>
        <td>{{ctx.organization.name}}</td>
      </tr>
      {% if ctx.createdBy %}
      <tr>
        <th>Created by</th>
        <td>{{ctx.createdBy.firstName}} {{ctx.createdBy.lastName}} (<a href="mailto:{{ctx.createdBy.email}}">{{ctx.createdBy.email}}</a>)</td>
      </tr>
      {% endif %}
      <tr>
        <th>Based on</th>
        <td>{{ctx.package.name}}, {{ctx.package.version}} (<span class="package-id"><span class="organization-id">{{ctx.package.organizationId}}</span>:<span class="km-id">{{ctx.package.kmId}}</span>:<span class="version">{{ctx.package.version}}</span></span>)</td>
      </tr>
      {% if ctx.config.levelsEnabled %}
      <tr>
        <th>Project Phase</th>
        <td>
          {% for levelDefinition in levelDefinitions %}
            {% if levelDefinition.level == ctx.level %}
              {{levelDefinition.title}}
            {% endif %}
          {% endfor %}
        </td>
      </tr>
      {% endif %}
      <tr>
        <th>Created at</th>
        <td>{{ ctx.createdAt|datetime_format("%d %b %Y") }}</td>
      </tr>
    </table>
  </header>
{%- endmacro -%}
{%- macro renderFooter() -%}
  <footer>
    Data Management Plan generated by Data Stewardship Wizard &lt;<a href="https://ds-wizard.org" target="_blank">https://ds-wizard.org</a>&gt;
  </footer>
{%- endmacro -%}
{%- macro renderContent() -%}
  <main>
    {% for chapterUuid in km.chapterUuids %}
      {{ renderChapter(km.entities.chapters[chapterUuid], loop.index) }}
    {% else %}
      <p class="text-light">No chapters</p>
    {% endfor %}
  </main>
{%- endmacro -%}
{# ------------------------------------------------------------------------------------ #}
{#  HTML TEMPLATE                                                                       #}
{# ------------------------------------------------------------------------------------ #}
<html>
  <head>
    <title>Data Management Plan</title>
    <meta charset="utf-8">
    <style>{% include "default.css" %}</style>
  </head>
  <body>
    <article class="dmp">
      {{ renderHeader() }}
      {{ renderContent() }}
      {{ renderFooter() }}
    </article>
  </body>
</html>
|]

css :: String
css =
  [r|
/**************************/
/* GENERAL STYLE          */
/**************************/

body {
  max-width: 1000px;
  margin: auto;
  font-family: sans-serif;
  font-size: .95rem;
}

h1, h2, h3, h4, h5, h6 {
  color: #333;
}

h3, h4 {
  margin-top: 1.33em;
  margin-bottom: 0.5em;
}

a {
  color: #868e96;
}

.text-light {
  color: #868e96!important;
}

.text-muted {
  color: #AEA79F!important;
}

/**************************/

header {
  padding-bottom: 1rem;
  border-bottom: solid 3px #aaaaaa;
}

header > h1 {
  font-size: 200%;
  margin: 0.5rem 0 ;
  line-height: 3rem;
  vertical-align: middle;
}

header > h1 > div.headline {
  float: left;
  margin-left: 1rem;
}

header > h1 > div.headline > span.km-name {
  color: #868e96;
  font-size: 75%;
  font-style: italic;
}

header > h1 > svg {
  float: left;
  height: 40px;
  width: 50px;
  vertical-align: middle;
  margin: 0.5rem;
}

header h1::after,
header::after {
  content: "";
  display: block;
  clear: both;
}

/**************************/

dl {
  color: #868e96;
}

dl dt {
  display: inline-block;
  width: 15%;
  padding: 0.2rem 0;
  float: left;
}

dl dt::after {
  content: ":";
}

dl dd {
  display: inline-block;
  width: 85%;
  margin: 0;
  padding: 0.2rem 0;
  float: left;
  font-style: italic;
}

dl dt > span.package-id {
  font-family: monospace;
  font-style: normal;
}

/**************************/

table {
  border-spacing: 0;
}

table th {
  padding: 0.5rem;
  border-right: 1px solid #E1E1E1;
  border-bottom: 1px solid #E1E1E1;
}

table th:first-child {
  border-left: 1px solid #E1E1E1;
}

table tr:first-child td,
table tr:first-child th {
  border-top: 1px solid #E1E1E1;
}

table td {
  padding: 0.5rem;
  border-right: 1px solid #E1E1E1;
  border-bottom: 1px solid #E1E1E1;
  text-align: center;
}

table td:first-child {
  border-left: 1px solid #E1E1E1;
  text-align: left;
}

/**************************/

footer {
  padding: 0.5em 0.5em 0.5em 0.5em;
  text-align: center;
  font-size: 90%;
}

/**************************/
/* KM-SPECIFIC STYLE      */
/**************************/

.report {
  margin-bottom: 1rem;
}

/**************************/

.chapter {
  border-bottom: solid 2px #cccccc;
}

/**************************/

.question, .answer-item {
  padding: 5px 10px 25px 10px;
  border-left: 5px solid #ddd;
}

.question:last-child, .answer-item:last-child {
  padding-bottom: 5px;
}

.answer-item > .followups > .question, .questions > .question {
  border: none;
  padding-left: 0;
}

.question > h4 {
  margin-top: 0;
  margin-bottom: 0.5rem;
  font-size: 0.95rem;
  font-weight: bold;
}

.question .title .human-identifier {
  display: inline-block;
  padding: 0.1rem 0.5rem;
  margin-bottom: 0.25rem;
  margin-right: 0.25rem;
  border: 1px solid #999;
  border-radius: 0.25rem;
  color: #999;
  font-size: 0.75rem;
  vertical-align: middle;
}

.question .text {
  margin-top: 0;
  margin-bottom: 0.75rem;
}

.question > .extra-data {
  margin-bottom: 0.75rem;
}

.question b {
  font-weight: normal;
}

/**************************/

.tags, .experts, .references {
  color: #868e96;
  line-height: 1.5;
}

.tags b, .experts b, .reference b,
.tags i, .experts a, .reference a {
  vertical-align: middle;
}

.tags svg, .experts svg, .references svg {
  width: 13px;
  height: 14px;
  margin-right: 7px;
  vertical-align: middle;
  color: #495057;
}

.tag::after, .expert::after, .reference::after {
  content: ",";
}

.tag:last-of-type::after, .expert:last-of-type::after, .reference:last-of-type::after {
  content: " ";
}

/**************************/

.answer-block .answer {
  font-style: italic;
}

.answer-block .answer span {
  vertical-align: middle;
}

.answer-block .answer svg,
.no-answer svg {
  height: 20px;
  width: 20px;
  margin-right: 0.3rem;
  vertical-align: middle;
}

.answer-item > .answer:first-child {
  margin-top: 0;
  margin-bottom: 25px;
}

.no-answer {
  font-weight: bold;
}

.no-answer span {
  vertical-align: middle;
}

.question.required .no-answer {
  color: #D0021B;
}

.question.optional .no-answer {
  color: #9B9B9B;
}

.integration-link {
  display: flex;
  align-items: center;
}

.integration-link img {
  max-height: 2rem;
  margin-right: .5rem;
}

.metrics > p {
  font-style: italic;
  margin-top: 0;
}
|]
