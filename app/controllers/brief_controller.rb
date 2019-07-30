class BriefController < ApplicationController

  layout 'tclub_project'

  def index
    @step =  0
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
        c = Contact.new(first_name: params[:firstname], last_name: params[:lastname], phone: params[:phone], email: params[:email], website: params[:website])
        c.project = project
        c.save
      end
      wiki = project.wiki
      wiki_page =  WikiPage.create(wiki_id: wiki.id, title: 'Wiki')
      WikiContent.create(page_id: wiki_page.id, text: content_wiki)
      Attachment.attach_files(wiki_page, params[:wiki_attachments])
    end
    redirect_to thank_you_brief_index_path
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

    output<< "h2. Vi vill skapa… (Kan välja fler) \n\r"

    if params[:checklist_1]
      output << "* En ny hemsida \n\r"
    end
    if params[:checklist_2]

      output << "* Redesign på befintlig hemsida\n\r"
    end
    if params[:checklist_3]
      output << "* En grafisk profi\n\r"
    end

    if params[:checklist_4]
      output << "* Rörligt material\n\r"

    end
    if params[:checklist_5]
      output << "* Annonsmaterial\n\r"
    end

    if params[:checklist_6]
      output << "* Tryckmaterial\n\r"
    end

    if params[:checklist_7]
      output << "* E-handel\n\r"
    end

    if params[:checklist_8]
      output << "* Annat\n\r"
    end

    output << "h3. Beskriv övergripande vad projektet innefattar?\n\r"
    output << "#{params[:project_innerfettar]} \n\r"

    output << "h3. Allmän information om ert företag och projektet\n\r"
    output << "#{params[:allman_information]} \n\r"
    output << "#{params[:vad_gor]} \n\r"
    output << "#{params[:vad_ar_det]} \n\r"
    output << "#{params[:vem_vilka]} \n\r"
    output << "#{params[:finns_det] } \n\r"
    output << "#{ params[:budget_indikerar] } \n\r"
    output << "#{ params[:beskriv_mening] } \n\r"
    output << "#{ params[:beskriv_ord] } \n\r"
    output << "#{ params[:vad_gor] } \n\r"
    output << "#{ params[:vad_gor_bra] } \n\r"
    output << "#{ params[:vad_diff] } \n\r"

    output << "h3. Allmän bild av ert företag \n\r"
    output << "#{ params[:om_ditt] } \n\r"
    output << "#{params[:hur_will] } \n\r"

    output << "h3. Konkurrens\n\r"
    output << "#{ params[:vilka_ar] } \n\r"
    output << "#{params[:hur_ar] } \n\r"

    output << "h3. Målgrupp\n\r"
    output << "#{params[:vem_ar] } \n\r"
    output << "#{ params[:hur_ar_er] } \n\r"
    output << "#{ params[:vilken] } \n\r"
    output << "#{ params[:hur_far_era] } \n\r"
    output << "#{ params[:vilken_ar] } \n\r"
    output << "#{ params[:vilka_kunder] } \n\r"

    output << "h3. Nuvarande grafiska identitet\n\r"
    output << "#{ params[:har_ni_en] } \n\r"
    output << "#{ params[:vad_tycker] } \n\r"

    output << "h3. Specifika frågor kring utveckling av hemsida\n\r"
    output << "#{ params[:varfor_behover] } \n\r"
    output << "#{params[:vad_ar_era] } \n\r"
    output << "#{ params[:vilka_delar] } \n\r"
    output << "#{ params[:vilka_delar_idag] } \n\r"
    output << "#{ params[:vad_vill] } \n\r"
    output << "#{ params[:lista_eventuellt] } \n\r"

    output << "h3. Något annat?\n\r"
    output << "#{params[:ar_det_nagot] } \n\r"
    output

  end

end
