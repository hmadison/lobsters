require 'rails_helper'

RSpec.describe Api::V1::UserActivityDelegate, type: :model do
  let(:user) { create(:user) }
  let(:user_url) { Rails.application.routes.url_helpers.user_url(user, host: 'example.com') }

  let(:activity) do
    {
      '@context': 'https://www.w3.org/ns/activitystreams',
     type: activity_type,
     actor: user_url,
     object: object
    }
  end

  describe 'Create' do
    let(:activity_type) { 'Create' }

    describe 'with a document' do
      let(:tag) { Tag.first }
      let(:object) do
        {
          type: 'Document',
          name: 'Sample Document',
          url: 'https://example.com/',
          tag: [
            {
              id: tag.tag,
              name: tag.tag
            }
          ]
        }
      end

      it 'returns a new story' do
        story = subject.call(activity)

        expect(story.user).to eq(user)
        expect(story.title).to eq(object[:name])
        expect(story.url).to eq(object[:url])
        expect(story.tags).to include(tag)
      end
    end

    describe 'with a comment on a story' do
      let(:story) { create(:story) }
      let(:story_url) { Rails.application.routes.url_helpers.story_url(story, host: 'example.com') }

      let(:object) do
        {
          type: 'Note',
          content: 'Hello',
          inReplyTo: story_url
        }
      end

      it 'returns a new comment' do
        comment = subject.call(activity)

        expect(comment.user).to eq(user)
        expect(comment.comment).to eq(object[:content])
        expect(comment.story).to eq(story)
      end
    end

    describe 'with a comment on a comment' do
      let(:comment) { create(:comment) }
      let(:comment_url) { Rails.application.routes.url_helpers.comment_url(comment, host: 'example.com') }

      let(:object) do
        {
          type: 'Note',
          content: 'Hello',
          inReplyTo: comment_url
        }
      end

      it 'returns a new comment' do
        comment = subject.call(activity)

        expect(comment.user).to eq(user)
        expect(comment.comment).to eq(object[:content])
        expect(comment.story).to eq(comment.story)
        expect(comment.parent_comment).to eq(comment.parent_comment)
      end
    end
  end

  describe 'Update' do
    let(:activity_type) { 'Update' }

    describe 'with a document' do
      let(:story) { create(:story, user: user) }
      let(:story_url) { Rails.application.routes.url_helpers.story_url(story, host: 'example.com') }

      let(:tag) { Tag.first }
      let(:object) do
        {
          id: story_url,
          type: 'Document',
          name: 'Sample Document',
          url: 'https://example.com/',
          tag: [
            {
              id: tag.tag,
              name: tag.tag
            }
          ]
        }
      end

      it 'returns an updated story object' do
        new_story = subject.call(activity)

        expect(new_story.user).to eq(user)
        expect(new_story.title).to eq(object[:name])
        expect(new_story.tags).to include(tag)
      end
    end

    describe 'with a note' do
      let(:comment) { create(:comment, user: user) }
      let(:comment_url) { Rails.application.routes.url_helpers.comment_url(comment, host: 'example.com') }

      let(:object) do
        {
          type: 'Note',
          content: 'Hello',
          id: comment_url
        }
      end

      it 'returns an updated story object' do
        new_comment = subject.call(activity)

        expect(new_comment.user).to eq(user)
        expect(new_comment.comment).to eq(object[:content])
      end
    end
  end

  describe 'Delete' do
    let(:activity_type) { 'Delete' }

    describe 'with a story' do
      let(:story) { create(:story, user: user) }
      let(:object) { Rails.application.routes.url_helpers.story_url(story, host: 'example.com') }

      it 'soft deletes the story' do
        deleted_story = subject.call(activity)
        expect(deleted_story.is_expired).to eq(true)
      end
    end

    describe 'wtih a comment' do
      let(:comment) { create(:comment, user: user) }
      let(:object) { Rails.application.routes.url_helpers.comment_url(comment, host: 'example.com') }

      it 'soft deletes the comment' do
        deleted_comment = subject.call(activity)
        expect(deleted_comment.is_deleted).to eq(true)
      end
    end
  end

  describe 'Like' do
    let(:activity_type) { 'Like' }

    describe 'with a story' do
      let(:story) { create(:story, user: user) }
      let(:object) { Rails.application.routes.url_helpers.story_url(story, host: 'example.com') }

      it 'votes a story up' do
        expect{subject.call(activity)}.to change{Vote.count}.by(1)
      end
    end

    describe 'with a comment' do
      let(:comment) { create(:comment, user: user) }
      let(:object) { Rails.application.routes.url_helpers.comment_url(comment, host: 'example.com') }

      it 'votes a story up' do
        expect{subject.call(activity)}.to change{Vote.count}.by(2)
      end
    end
  end

  describe 'Undo' do
    let(:activity_type) { 'Undo' }

    describe 'with a story' do
      let(:story) { create(:story) }
      let(:object) { Rails.application.routes.url_helpers.story_url(story, host: 'example.com') }

      it 'votes a story to zero' do
        expect{subject.call(activity)}.to change{Vote.count}.by(1)
      end
    end

    describe 'with a comment' do
      let(:comment) { create(:comment) }
      let(:object) { Rails.application.routes.url_helpers.comment_url(comment, host: 'example.com') }

      it 'votes a comment to zero' do
        expect{subject.call(activity)}.to change{Vote.count}.by(2)
      end
    end
  end
end
