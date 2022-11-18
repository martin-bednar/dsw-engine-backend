module Wizard.Service.KnowledgeModel.Compilator.EventApplicator.Answer where

import Prelude hiding (lookup)

import Shared.Model.Event.Answer.AnswerEvent
import Shared.Model.Event.EventLenses
import Wizard.Service.KnowledgeModel.Compilator.EventApplicator.EventApplicator
import Wizard.Service.KnowledgeModel.Compilator.Modifier.Answer ()
import Wizard.Service.KnowledgeModel.Compilator.Modifier.Chapter ()
import Wizard.Service.KnowledgeModel.Compilator.Modifier.Delete
import Wizard.Service.KnowledgeModel.Compilator.Modifier.Expert ()
import Wizard.Service.KnowledgeModel.Compilator.Modifier.Integration ()
import Wizard.Service.KnowledgeModel.Compilator.Modifier.KnowledgeModel ()
import Wizard.Service.KnowledgeModel.Compilator.Modifier.Metric ()
import Wizard.Service.KnowledgeModel.Compilator.Modifier.Phase ()
import Wizard.Service.KnowledgeModel.Compilator.Modifier.Question ()
import Wizard.Service.KnowledgeModel.Compilator.Modifier.Reference ()
import Wizard.Service.KnowledgeModel.Compilator.Modifier.Tag ()

instance ApplyEvent AddAnswerEvent where
  apply = applyCreateEventWithParent getAnswersM setAnswersM getQuestionsM setQuestionsM getAnswerUuids setAnswerUuids

instance ApplyEvent EditAnswerEvent where
  apply = applyEditEvent getAnswersM setAnswersM

instance ApplyEvent DeleteAnswerEvent where
  apply event km =
    deleteEntityReferenceFromParentNode event getQuestionsM setQuestionsM getAnswerUuids setAnswerUuids $ deleteAnswer km (getEntityUuid event)
