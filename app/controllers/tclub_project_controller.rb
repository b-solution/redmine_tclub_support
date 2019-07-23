class TclubProjectController < ApplicationController

  layout 'tclub_project'

  def index
    @step =  50
  end

  def thank_you

  end

  def create
    project = Project.new(name: params[:project_name], identifier: params[:project_name].to_s.parameterize)
    if project.save
      # if project && Setting.plugin_redmine_tclub_support['logo'].present? &&
      #     ( cfv = project.custom_field_values.detect {|c| c.custom_field_id.to_s == Setting.plugin_redmine_tclub_support['logo']} )
      #   Attachment.attach_files(cfv, params[:attachments])
      # end

      # create contact
      if defined? Contact
        Contact.create(first_name: params[:firstname], last_name: params[:lastname], phone: params[:phone], email: params[:email], website: params[:website])
      end
      wiki = project.wiki
      wiki_page =  WikiPage.create(wiki_id: wiki.id, title: 'Wiki')
      WikiContent.create(page_id: wiki_page.id, text: content_wiki)
      Attachment.attach_files(wiki_page, params[:wiki_attachments])
    end
    redirect_to thank_you_tclub_project_index_path
  end

  def check_project
    respond_to do |format|
      format.json{
        project = Project.new(name: params[:project_name], identifier: params[:project_name].to_s.parameterize)
        if project.valid?
          render json: {success: true}
        else
          render json: {success: false, errors: project.errors.full_messages.join('<br/>').html_safe}
        end
      }
    end
  end

  private
  def content_wiki
    output = ''

    output<< "h2. Vi vill skapa… (Kan välja fler) \n"

    if params[:checklist_1]
      output << "- En ny hemsida \n"
    end
    if params[:checklist_2]

      output << "-  Redesign på befintlig hemsida\n"
    end
    if params[:checklist_3]
      output << "-  En grafisk profi\n"
    end

    if params[:checklist_4]
      output << "-  Rörligt material\n"

    end
    if params[:checklist_5]
      output << "-   Annonsmaterial\n"
    end

    if params[:checklist_6]
      output << "-  Tryckmaterial\n"
    end

    if params[:checklist_7]
      output << "-   E-handel\n"
    end

    if params[:checklist_8]
      output << "-  Annat\n"
    end

    output << "h3. Beskriv övergripande vad projektet innefattar?\n"
    output << "#{params[:project_innerfettar]} \n"

    output << "h3. Allmän information om ert företag och projektet\n"
    output << "#{params[:allman_information]} \n"
    output << "#{params[:vad_gor]} \n"
    output << "#{params[:vad_ar_det]} \n"
    output << "#{params[:vem_vilka]} \n"
    output << "#{params[:finns_det] } \n"
    output << "#{ params[:budget_indikerar] } \n"
    output << "#{ params[:beskriv_mening] } \n"
    output << "#{ params[:beskriv_ord] } \n"
    output << "#{ params[:vad_gor] } \n"
    output << "#{ params[:vad_gor_bra] } \n"
    output << "#{ params[:vad_diff] } \n"

    output << "h3. Allmän bild av ert företag \n"
    output << "#{ params[:om_ditt] } \n"
    output << "#{params[:hur_will] } \n"

    output << "h3. Konkurrens\n"
    output << "#{ params[:vilka_ar] } \n"
    output << "#{params[:hur_ar] } \n"

    output << "h3. Målgrupp\n"
    output << "#{params[:vem_ar] } \n"
    output << "#{ params[:hur_ar_er] } \n"
    output << "#{ params[:vilken] } \n"
    output << "#{ params[:hur_far_era] } \n"
    output << "#{ params[:vilken_ar] } \n"
    output << "#{ params[:vilka_kunder] } \n"

    output << "h3. Nuvarande grafiska identitet\n"
    output << "#{ params[:har_ni_en] } \n"
    output << "#{ params[:vad_tycker] } \n"

    output << "h3. Specifika frågor kring utveckling av hemsida\n"
    output << "#{ params[:varfor_behover] } \n"
    output << "#{params[:vad_ar_era] } \n"
    output << "#{ params[:vilka_delar] } \n"
    output << "#{ params[:vilka_delar_idag] } \n"
    output << "#{ params[:vad_vill] } \n"
    output << "#{ params[:lista_eventuellt] } \n"

    output << "h3. Något annat?\n"
    output << "#{params[:ar_det_nagot] } \n"
    output

  end

end
