class QuestionsData {
  static List<Map<String, dynamic>> getQuestionsForCategory(String category) {
    switch (category) {
      case 'businessModel':
        return _businessModelQuestions;
      case 'productInnovation':
        return _productInnovationQuestions;
      case 'processInnovation':
        return _processInnovationQuestions;
      case 'customerExperience':
        return _customerExperienceQuestions;
      case 'technologyAdoption':
        return _technologyAdoptionQuestions;
      default:
        return [];
    }
  }

  static final List<Map<String, dynamic>> _businessModelQuestions = [
    {
      'question': 'How often does your company review and update its business model?',
      'options': [
        'Never or rarely (less than once every 5 years)',
        'Occasionally (once every 3-5 years)',
        'Regularly (once every 1-2 years)',
        'Frequently (multiple times per year)',
        'Continuously (as part of our ongoing strategy process)',
      ],
    },
    {
      'question': 'How does your company approach revenue streams?',
      'options': [
        'We rely solely on traditional, established revenue models',
        'We occasionally explore new pricing or revenue approaches',
        'We regularly test alternative revenue models',
        'We actively manage a portfolio of revenue streams',
        'We continually innovate with multiple, diverse revenue models',
      ],
    },
    {
      'question': 'How would you describe your company\'s approach to partnerships?',
      'options': [
        'We rarely collaborate with external partners',
        'We have a few established partnerships but don\'t actively seek new ones',
        'We sometimes explore new partnerships when opportunities arise',
        'We proactively seek strategic partnerships to complement our business',
        'We have an ecosystem approach with multiple integrated partnerships',
      ],
    },
    {
      'question': 'How does your company handle business model experiments?',
      'options': [
        'We don\'t experiment with our business model',
        'We occasionally make small adjustments to our model',
        'We sometimes test new business model elements in controlled settings',
        'We regularly run business model experiments in the market',
        'We have a systematic process for continuous business model innovation',
      ],
    },
    {
      'question': 'How does your company respond to disruptive business models in your industry?',
      'options': [
        'We typically ignore them until they directly impact our business',
        'We monitor them but rarely change our approach in response',
        'We analyze them and selectively adapt elements that make sense for us',
        'We quickly develop competitive responses to disruptive models',
        'We proactively create potentially disruptive models ourselves',
      ],
    },
  ];

  static final List<Map<String, dynamic>> _productInnovationQuestions = [
    {
      'question': 'How does your company approach new product development?',
      'options': [
        'We rarely develop new products or services',
        'We occasionally update existing products based on market feedback',
        'We regularly develop new products based on customer needs',
        'We have a structured innovation process for continuous product development',
        'We systematically disrupt our own products before competitors do',
      ],
    },
    {
      'question': 'How does your company involve customers in product development?',
      'options': [
        'We rarely involve customers in our product development process',
        'We gather customer feedback after launching new products',
        'We occasionally test concepts or prototypes with customers',
        'We regularly co-create products with customers throughout the process',
        'We have continuous customer involvement embedded in our development methodology',
      ],
    },
    {
      'question': 'How does your company approach product testing and iteration?',
      'options': [
        'We launch finished products with little or no testing',
        'We test products internally before full launch',
        'We conduct limited market testing with select customers',
        'We release minimum viable products and iterate based on feedback',
        'We have a continuous build-measure-learn approach to product development',
      ],
    },
    {
      'question': 'How frequently does your company introduce new products or services?',
      'options': [
        'Rarely (less than once every 3 years)',
        'Occasionally (once every 1-3 years)',
        'Regularly (annually)',
        'Frequently (multiple times per year)',
        'Continuously (ongoing stream of new offerings)',
      ],
    },
    {
      'question': 'How does your company measure product innovation success?',
      'options': [
        'We don\'t systematically measure innovation success',
        'We track basic metrics like sales of new products',
        'We measure product performance against pre-defined targets',
        'We use a balanced scorecard of innovation metrics',
        'We have sophisticated innovation analytics tied to business outcomes',
      ],
    },
  ];

  static final List<Map<String, dynamic>> _processInnovationQuestions = [
    {
      'question': 'How does your company approach operational process improvement?',
      'options': [
        'We maintain processes until they clearly need changing',
        'We make incremental improvements when problems arise',
        'We regularly review and optimize our key processes',
        'We systematically analyze and redesign processes for efficiency',
        'We continuously innovate our processes using advanced methodologies',
      ],
    },
    {
      'question': 'How does your company leverage automation and digital tools?',
      'options': [
        'We use minimal automation and primarily manual processes',
        'We have automated some routine tasks in isolated areas',
        'We have moderate automation across several business functions',
        'We have significant automation and digital workflows in most areas',
        'We have advanced, integrated automation throughout our organization',
      ],
    },
    {
      'question': 'How does your company utilize data in process improvement?',
      'options': [
        'We rarely collect or analyze data about our processes',
        'We occasionally review data when addressing specific issues',
        'We regularly analyze operational data to identify improvement areas',
        'We have data-driven continuous improvement embedded in operations',
        'We use advanced analytics and AI to optimize and predict process performance',
      ],
    },
    {
      'question': 'How agile are your company\'s operational processes?',
      'options': [
        'Our processes are rigid and difficult to change',
        'We can make small adjustments to processes with effort',
        'Our key processes are moderately adaptable when needed',
        'Most of our processes are designed to be flexible and responsive',
        'We have highly adaptive processes that rapidly evolve with business needs',
      ],
    },
    {
      'question': 'How does your company approach workforce involvement in process innovation?',
      'options': [
        'Process changes are top-down with minimal employee input',
        'We occasionally gather feedback from employees on processes',
        'We have channels for employees to suggest process improvements',
        'We actively engage employees in redesigning their own workflows',
        'Our culture empowers employees to continuously innovate processes',
      ],
    },
  ];

  static final List<Map<String, dynamic>> _customerExperienceQuestions = [
    {
      'question': 'How does your company gather customer insights?',
      'options': [
        'We rarely collect customer feedback formally',
        'We occasionally conduct customer surveys or focus groups',
        'We regularly use multiple methods to gather customer feedback',
        'We have systematic, continuous customer insight collection',
        'We use advanced customer analytics and behavioral data collection',
      ],
    },
    {
      'question': 'How does your company map and design customer journeys?',
      'options': [
        'We don\'t formally map customer journeys',
        'We have basic understanding of our customer touchpoints',
        'We have documented and analyzed key customer journeys',
        'We actively design and optimize customer journeys across channels',
        'We personalize journeys in real-time based on customer behavior and preferences',
      ],
    },
    {
      'question': 'How does your company measure customer experience?',
      'options': [
        'We don\'t systematically measure customer experience',
        'We track basic metrics like customer satisfaction',
        'We regularly measure metrics like NPS or CSAT across touchpoints',
        'We have a comprehensive CX measurement system tied to business outcomes',
        'We use real-time experience measurement with predictive capabilities',
      ],
    },
    {
      'question': 'How personalized is your customer experience?',
      'options': [
        'We offer one-size-fits-all experiences to all customers',
        'We have basic segmentation with slightly different approaches',
        'We offer moderately personalized experiences based on customer segments',
        'We have highly personalized experiences across most touchpoints',
        'We deliver hyper-personalized, context-aware experiences in real-time',
      ],
    },
    {
      'question': 'How does your company handle customer feedback and complaints?',
      'options': [
        'We have minimal processes for handling customer issues',
        'We address complaints reactively as they arise',
        'We have established processes for addressing and tracking issues',
        'We systematically analyze feedback to identify improvement opportunities',
        'We have closed-loop processes that turn feedback into innovation',
      ],
    },
  ];

  static final List<Map<String, dynamic>> _technologyAdoptionQuestions = [
    {
      'question': 'How does your company approach emerging technologies?',
      'options': [
        'We rarely adopt new technologies',
        'We adopt new technologies only when necessary for business continuity',
        'We occasionally evaluate and adopt proven technologies',
        'We regularly assess emerging technologies for potential adoption',
        'We actively experiment with cutting-edge technologies',
      ],
    },
    {
      'question': 'How does your company invest in technology infrastructure?',
      'options': [
        'We minimize tech investments and maintain legacy systems',
        'We upgrade technologies when they no longer meet basic needs',
        'We make regular investments to keep our technology current',
        'We strategically invest in advanced technologies for competitive advantage',
        'We continuously evolve our technology stack with state-of-the-art solutions',
      ],
    },
    {
      'question': 'How does your company approach digital transformation?',
      'options': [
        'We have made minimal progress toward digital transformation',
        'We have digitized some basic processes and functions',
        'We are implementing a strategic digital transformation roadmap',
        'We have significantly transformed most aspects of our business digitally',
        'Our business is natively digital and continuously evolving',
      ],
    },
    {
      'question': 'How does your company utilize data and analytics?',
      'options': [
        'We collect minimal data and use basic reporting',
        'We have standard reporting on key business metrics',
        'We actively analyze data to inform business decisions',
        'We leverage advanced analytics for insights and predictions',
        'We have AI-driven decision-making embedded throughout our operations',
      ],
    },
    {
      'question': 'How does your company approach technology skills development?',
      'options': [
        'We rarely invest in developing new technology skills',
        'We provide basic training when implementing new technologies',
        'We regularly upskill employees on current technologies',
        'We proactively develop capabilities in emerging technologies',
        'We have a continuous learning culture focused on technology mastery',
      ],
    },
  ];
}