FactoryGirl.define do

  factory :answer do
    completion
    question
    text 'Hello'
  end

  factory :completion do
    survey
    user
  end

  factory :option do
    text 'Hello'
  end

  factory :question do
    survey
    title 'Question'
    question_type 'Open'

    factory :multiple_choice_question do
      ignore do
        options_texts { [] }
      end

      options do |attributes|
        attributes.options_texts.map do |text|
          FactoryGirl.build(:option, text: text, question_id: attributes.id)
        end
      end

      question_type 'MultipleChoice'
    end

    factory :open_question do
      question_type 'Open'
    end

    factory :scale_question do
      question_type 'Scale'
    end
  end

  factory :survey do
    title 'Survey'
  end

end
